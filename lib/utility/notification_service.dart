import 'dart:isolate';
import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show ValueNotifier, debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/language_settings.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

// dart:developer's log() never reliably reaches adb logcat on this project's
// builds (confirmed empirically — tried it first, found zero output even
// with verbose logcat captures), which is why every earlier diagnostic
// logging pass here looked like it produced nothing. debugPrint() goes
// through Flutter's own stdout bridge (tag "flutter"), which does show up,
// in debug *and* release builds.
void _log(String message) => debugPrint('[NotificationService] $message');

const String _kChannelId = 'prayer_reminders';
const String _kChannelName = 'Prayer reminders';
const String _kTestReminderPayload = '__test_reminder__';
const String _kAdhanChannelId = 'prayer_adhan';
const String _kAdhanChannelName = 'Prayer Adhan';
const String _kHabitReminderChannelId = 'habit_reminders';
const String _kHabitReminderChannelName = 'Habit reminders';
const String _kHabitReminderPayloadPrefix = 'habit_reminder:';
// Reserved ID range for per-habit reminders. Prayer reminders use 0-4, adhan
// 10-14 and the Settings test 99, so this cannot collide. Each habit owns
// _kHabitReminderIdStride consecutive IDs so it can hold one slot per selected
// weekday or a rolling window of interval occurrences.
const int _kHabitReminderIdBase = 1000;
const int _kHabitReminderIdStride = 64;
// Android's local-notification scheduler can only repeat daily or weekly, so
// habits that run every N days get their upcoming occurrences as one-shots.
// The window is refreshed whenever reminders are rescheduled.
const int _kRepeatingReminderHorizon = 30;
const String _kHabitUpdatePortName = 'islamic_habits_habit_updates';

class _HabitReminderOccurrence {
  final int slot;
  final tz.TZDateTime date;
  final DateTimeComponents? repeat;

  const _HabitReminderOccurrence({
    required this.slot,
    required this.date,
    this.repeat,
  });
}

// Notification actions that arrive while the app isn't foregrounded are
// handled on a background isolate. Its statics (including habitDataRevision)
// are separate from the UI isolate's, so it needs to message the UI isolate
// over a named port after writing to the database.
bool _isBackgroundResponse = false;

String _adhanSoundResource(AdhanVoiceOption voice, bool takbeerOnly) =>
    takbeerOnly ? voice.takbeerResource : voice.fullResource;

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Resolves the same locale the app's UI is currently showing, without a
// BuildContext (notifications are scheduled from outside the widget tree).
// Android lays out the notification text itself, so an Arabic string here
// renders right-to-left automatically — no extra RTL handling needed.
Future<AppLocalizations> _currentLocalizations() async {
  Locale locale = LanguageSettings.locale ?? PlatformDispatcher.instance.locale;
  if (!kSupportedLocales.any((l) => l.languageCode == locale.languageCode)) {
    locale = const Locale('en');
  } else {
    locale = Locale(locale.languageCode);
  }
  return AppLocalizations.delegate.load(locale);
}

String _localizedPrayerName(AppLocalizations l10n, int index) {
  const names = [
    'prayerFajr',
    'prayerDhuhr',
    'prayerAsr',
    'prayerMaghrib',
    'prayerIsha',
  ];
  switch (names[index]) {
    case 'prayerFajr':
      return l10n.prayerFajr;
    case 'prayerDhuhr':
      return l10n.prayerDhuhr;
    case 'prayerAsr':
      return l10n.prayerAsr;
    case 'prayerMaghrib':
      return l10n.prayerMaghrib;
    default:
      return l10n.prayerIsha;
  }
}

// Reminders fire 30 minutes after each prayer's calculated time, asking
// whether the prayer was performed; answering Yes/No marks that habit's
// data for today directly, without opening the app.
class NotificationService {
  // Bumped whenever a notification action writes habit data. Screens that
  // hold an in-memory Habit list listen to this and reload from the database,
  // so a Yes/No tapped on the notification shows up immediately without
  // needing an app restart.
  static final ValueNotifier<int> habitDataRevision = ValueNotifier<int>(0);

  static ReceivePort? _habitUpdatePort;
  static bool _habitUpdatePortRegistered = false;

  // Listens for "habit data changed" messages sent by a background-isolate
  // notification action. The port is kept alive for the app's lifetime.
  static void _ensureHabitUpdatePort() {
    if (_habitUpdatePortRegistered) return;
    final existing = IsolateNameServer.lookupPortByName(_kHabitUpdatePortName);
    if (existing != null) {
      IsolateNameServer.removePortNameMapping(_kHabitUpdatePortName);
    }
    _habitUpdatePort = ReceivePort();
    _habitUpdatePort!.listen((message) async {
      try {
        if (message is Map) {
          final actionId = message['actionId'];
          if (actionId is! String) return;
          bool recorded = false;
          if (message['type'] == 'habit') {
            final habitId = message['habitId'];
            if (habitId is int) {
              recorded =
                  await _recordHabitReminderResponse(habitId, actionId);
            }
          } else {
            final prayerName = message['prayerName'];
            if (prayerName is String) {
              recorded = await _recordHabitResponse(prayerName, actionId);
            }
          }
          if (recorded) habitDataRevision.value++;
        }
      } catch (e) {
        _log('Failed applying forwarded habit response: $e');
      }
    });
    IsolateNameServer.registerPortWithName(
        _habitUpdatePort!.sendPort, _kHabitUpdatePortName);
    _habitUpdatePortRegistered = true;
  }

  static Future<void> initialize() async {
    _ensureHabitUpdatePort();
    tz.initializeTimeZones();
    // Without this, tz.local silently stays UTC, so every zonedSchedule
    // below computes the wrong wall-clock instant — in most timezones that
    // instant is already in the past by the time it's scheduled, so the
    // notification is just dropped, which is why reminders never fired
    // despite scheduling appearing to succeed.
    try {
      final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
      // Some Android builds still report the old (renamed) IANA name, which
      // the timezone package can no longer resolve. Map the common ones to
      // their current names before giving up and staying on UTC.
      const aliases = <String, String>{
        'Europe/Kiev': 'Europe/Kyiv',
        'Asia/Calcutta': 'Asia/Kolkata',
        'Asia/Katmandu': 'Asia/Kathmandu',
        'Asia/Rangoon': 'Asia/Yangon',
        'America/Godthab': 'America/Nuuk',
      };
      final resolvedName = aliases[deviceTimeZone] ?? deviceTimeZone;
      tz.setLocalLocation(tz.getLocation(resolvedName));
      _log('Resolved device timezone: $deviceTimeZone '
          '($resolvedName, tz.local=${tz.local.name})');
    } catch (e) {
      // Falls back to UTC if the platform can't report a timezone; better
      // than crashing, though reminder times will be off until this works.
      _log('Failed to resolve device timezone, staying on UTC: $e');
    }
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse: _handleBackgroundResponse,
    );
    final canExact = await _androidPlugin()?.canScheduleExactNotifications();
    _log('canScheduleExactNotifications: $canExact');
    await _createReminderChannel();
    await _createHabitReminderChannel();
    await ensureAdhanChannelMatchesSettings();
    await _deleteLegacyChannels();
  }

  // Normally a channel is only created the first time a notification is
  // posted to it, so without this "Prayer reminders" wouldn't show up under
  // the app's notification settings (Settings > Apps > Islamic Habits >
  // Notifications) until a reminder had actually fired at least once.
  static Future<void> _createReminderChannel() async {
    final plugin = _androidPlugin();
    if (plugin == null) return;
    try {
      await plugin.createNotificationChannel(const AndroidNotificationChannel(
        _kChannelId,
        _kChannelName,
        description: 'Reminders to log your prayer habits',
        importance: Importance.high,
        playSound: false,
        enableVibration: true,
      ));
    } catch (e) {
      _log('Failed creating reminder channel: $e');
    }
  }

  // Habit reminders have their own channel so they are independent of the
  // global prayer-reminder switch and show up as a separate category in the
  // system notification settings.
  static Future<void> _createHabitReminderChannel() async {
    final plugin = _androidPlugin();
    if (plugin == null) return;
    try {
      await plugin.createNotificationChannel(const AndroidNotificationChannel(
        _kHabitReminderChannelId,
        _kHabitReminderChannelName,
        description: 'Daily reminders for your custom habits',
        importance: Importance.high,
        playSound: false,
        enableVibration: true,
      ));
    } catch (e) {
      _log('Failed creating habit reminder channel: $e');
    }
  }

  // A notification channel's sound can't be changed after it's first
  // created, so the only way to have exactly one "Prayer Adhan" channel
  // (rather than one per voice/Takbeer combination) while still letting the
  // user change which voice plays is to delete and recreate this single
  // channel whenever the voice or Takbeer-only setting changes. Call this
  // once at startup and again after either setting is saved.
  static Future<void> ensureAdhanChannelMatchesSettings() async {
    final plugin = _androidPlugin();
    if (plugin == null) return;
    final voice = PrayerSettings.adhanVoice;
    final takbeerOnly = PrayerSettings.adhanTakbeerOnly;
    try {
      await plugin.deleteNotificationChannel(channelId: _kAdhanChannelId);
      await plugin.createNotificationChannel(AndroidNotificationChannel(
        _kAdhanChannelId,
        _kAdhanChannelName,
        description: 'Plays the adhan (reciter voice) at prayer time',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound(
            _adhanSoundResource(voice, takbeerOnly)),
      ));
      _log('Adhan channel recreated for voice=${voice.id}, '
          'takbeerOnly=$takbeerOnly');
    } catch (e) {
      _log('Failed recreating adhan channel: $e');
    }
  }

  // Android keeps a notification channel until the app explicitly deletes it,
  // so channels created by older builds (one per adhan voice) remain listed
  // under the app's notification settings even though this build only uses
  // the fixed channels above. Remove every other channel so the system
  // settings screen shows exactly "Prayer Adhan", "Prayer reminders" and
  // "Habit reminders".
  static Future<void> _deleteLegacyChannels() async {
    final plugin = _androidPlugin();
    if (plugin == null) return;
    try {
      final channels =
          await plugin.getNotificationChannels() ??
              const <AndroidNotificationChannel>[];
      final legacyGroupIds = <String>{};
      for (final channel in channels) {
        if (channel.id == _kChannelId ||
            channel.id == _kAdhanChannelId ||
            channel.id == _kHabitReminderChannelId) {
          continue;
        }
        if (channel.groupId != null) {
          legacyGroupIds.add(channel.groupId!);
        }
        await plugin.deleteNotificationChannel(channelId: channel.id);
        _log('Deleted legacy notification channel: ${channel.id}');
      }
      // The old per-voice channels were also grouped; deleting the channels
      // leaves the empty group behind in the system notification settings.
      for (final groupId in legacyGroupIds) {
        await plugin.deleteNotificationChannelGroup(groupId: groupId);
        _log('Deleted legacy notification channel group: $groupId');
      }
    } catch (e) {
      _log('Failed deleting legacy notification channels: $e');
    }
  }

  static AndroidFlutterLocalNotificationsPlugin? _androidPlugin() =>
      _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static Future<bool> requestPermission() async {
    final granted = await _androidPlugin()?.requestNotificationsPermission();
    return granted ?? false;
  }

  // Many OEMs (Xiaomi, Samsung, etc.) aggressively kill background alarms
  // for apps that aren't exempted from battery optimization, even when the
  // alarm itself is scheduled correctly. This opens the system dialog that
  // lets the user exempt the app directly; there's no way to do this
  // silently, and no reliable way to check whether it's already granted.
  static Future<void> requestIgnoreBatteryOptimizations() async {
    const intent = AndroidIntent(
      action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
      data: 'package:dev.smoothchocolate.islamic_habits',
    );
    await intent.launch();
  }

  // On Android 12+, alarms scheduled without this get silently downgraded
  // to "inexact", which Doze can delay by a long, unpredictable margin —
  // not acceptable for a 30-minutes-after-prayer reminder. This opens the
  // system "Alarms & reminders" screen so the user can grant it directly.
  // Returns the granted state so the caller can tell the user something —
  // when it's already granted, the plugin resolves immediately without
  // showing any system UI, which otherwise looks like the button does
  // nothing at all.
  static Future<bool> requestExactAlarmPermission() async {
    final plugin = _androidPlugin();
    final result = await plugin?.requestExactAlarmsPermission();
    _log('requestExactAlarmsPermission result: $result');
    return result ?? false;
  }

  // Cancels pending prayer notifications. IDs listed in [preserveIds] are
  // left untouched so a notification that has already been delivered stays
  // visible when the app reschedules (e.g. on resume right after it fired).
  static Future<void> cancelAllPrayerReminders({
    Set<int> preserveIds = const <int>{},
  }) async {
    for (int i = 0; i < kPrayersNames.length; i++) {
      if (!preserveIds.contains(i)) {
        await _notificationsPlugin.cancel(id: i);
      }
      if (!preserveIds.contains(10 + i)) {
        await _notificationsPlugin.cancel(id: 10 + i);
      }
    }
  }

  // Schedules today's remaining prayers. The two notification types are
  // independent:
  //   - Adhan (id 10+i): controlled by the per-prayer bell; only
  //     PrayerNotifyMode.adhan schedules it, at the prayer time.
  //   - "Did you pray?" reminder (id i): controlled ONLY by the global
  //     PrayerSettings.remindersEnabled switch, 30 minutes after every
  //     prayer, regardless of that prayer's bell mode.
  // Called whenever the app starts/resumes; there is no background job to
  // reschedule the next day on its own.
  static Future<void> scheduleTodayReminders() async {
    // Notifications that are already posted must survive this reschedule.
    // Otherwise opening the app a few seconds after a reminder fires would
    // cancel it (and then skip re-adding it because its time has passed).
    Set<int> activeIds = const <int>{};
    try {
      activeIds = (await _notificationsPlugin.getActiveNotifications())
          .map((n) => n.id)
          .whereType<int>()
          .toSet();
    } catch (e) {
      _log('Could not read active notifications: $e');
    }
    await cancelAllPrayerReminders(preserveIds: activeIds);

    final canExact = await _androidPlugin()?.canScheduleExactNotifications();
    final scheduleMode = canExact == true
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    _log('scheduleTodayReminders: canExact=$canExact, using $scheduleMode, '
        'now=${DateTime.now()}, tz.local=${tz.local.name}');
    if (PrayerSettings.prayerModes.contains(PrayerNotifyMode.adhan)) {
      await ensureAdhanChannelMatchesSettings();
    }

    final l10n = await _currentLocalizations();
    final prayerHelper = PrayerHelper.fromSettings();
    final prayerTimes = [
      prayerHelper.getFajr(),
      prayerHelper.getDhuhr(),
      prayerHelper.getAsr(),
      prayerHelper.getMaghrib(),
      prayerHelper.getIsha(),
    ];
    final now = DateTime.now();

    for (int i = 0; i < prayerTimes.length; i++) {
      final mode = PrayerSettings.prayerModes[i];
      // The payload stays the canonical English key so it always matches
      // the stored habit name, regardless of display language.
      final habitPrayerName = kPrayersNames[i];
      final displayName = _localizedPrayerName(l10n, i);

      // Adhan at the prayer time — still driven by the per-prayer bell.
      if (mode == PrayerNotifyMode.adhan) {
        if (prayerTimes[i].isBefore(now)) {
          _log('  [$i] ${kPrayersNames[i]}: adhan time ${prayerTimes[i]} '
              'already passed, skipped');
        } else {
          final voice = PrayerSettings.adhanVoice;
          final takbeerOnly = PrayerSettings.adhanTakbeerOnly;
          try {
            await _notificationsPlugin.zonedSchedule(
              id: 10 + i,
              title: l10n.notificationPrayerTimeTitle,
              body: l10n.notificationPrayerTimeBody(displayName),
              scheduledDate: tz.TZDateTime.from(prayerTimes[i], tz.local),
              notificationDetails: NotificationDetails(
                android: AndroidNotificationDetails(
                  _kAdhanChannelId,
                  _kAdhanChannelName,
                  channelDescription: 'Plays the adhan at prayer time',
                  importance: Importance.high,
                  priority: Priority.high,
                  sound: RawResourceAndroidNotificationSound(
                      _adhanSoundResource(voice, takbeerOnly)),
                ),
              ),
              androidScheduleMode: scheduleMode,
            );
            _log('  [$i] ${kPrayersNames[i]}: adhan scheduled for '
                '${prayerTimes[i]}');
          } catch (e) {
            // No audio file bundled for this voice (see
            // android/app/ADHAN_AUDIO_README.md) — skip just this prayer
            // rather than aborting the rest of the day's reminders.
            _log('  [$i] ${kPrayersNames[i]}: adhan schedule FAILED: $e');
          }
        }
      } else if (mode == PrayerNotifyMode.silent) {
        _log('  [$i] ${kPrayersNames[i]}: silent at prayer time (no adhan)');
      }

      // 30-minute-later reminder — independent of the per-prayer bell;
      // gated only by the global "Prayer reminders" switch.
      if (!PrayerSettings.remindersEnabled) {
        _log('  [$i] ${kPrayersNames[i]}: reminders disabled, skipped');
        continue;
      }

      final reminderTime = prayerTimes[i].add(const Duration(minutes: 30));
      if (reminderTime.isBefore(now)) {
        _log('  [$i] ${kPrayersNames[i]}: reminder time $reminderTime '
            'already passed, skipped');
        continue;
      }
      await _notificationsPlugin.zonedSchedule(
        id: i,
        title: l10n.notificationReminderTitle,
        body: l10n.notificationReminderBody(displayName),
        scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _kChannelId,
            _kChannelName,
            channelDescription: 'Reminders to log your prayer habits',
            importance: Importance.high,
            priority: Priority.high,
            // The reminder is vibration-only; adhan mode (when enabled for
            // a prayer) plays the reciter at prayer time instead.
            playSound: false,
            enableVibration: true,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction('yes', l10n.notificationYes,
                  cancelNotification: true),
              AndroidNotificationAction('no', l10n.notificationNo,
                  cancelNotification: true),
            ],
          ),
        ),
        androidScheduleMode: scheduleMode,
        payload: habitPrayerName,
      );
      _log('  [$i] ${kPrayersNames[i]}: reminder scheduled for '
          '$reminderTime (payload=$habitPrayerName)');
    }
  }

  // Clears the previously scheduled habit reminders and schedules them again
  // according to each habit's own schedule: daily habits repeat every day,
  // weekday habits repeat on their selected days, and interval habits get a
  // rolling window of one-shot reminders. Deliberately does not read
  // PrayerSettings.remindersEnabled: habit reminders are independent of the
  // global prayer-reminder setting.
  static Future<void> scheduleHabitReminders() async {
    final plugin = _notificationsPlugin;
    try {
      final pending = await plugin.pendingNotificationRequests();
      for (final request in pending) {
        if (request.id >= _kHabitReminderIdBase &&
            request.id < _kHabitReminderIdBase + 100000) {
          await plugin.cancel(id: request.id);
        }
      }
    } catch (e) {
      _log('Could not clear previous habit reminders: $e');
    }

    final habits = await HabitDao().getActive();
    final l10n = await _currentLocalizations();
    final canExact = await _androidPlugin()?.canScheduleExactNotifications();
    final scheduleMode = canExact == true
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    final now = tz.TZDateTime.now(tz.local);
    _log('scheduleHabitReminders: canExact=$canExact, using $scheduleMode, '
        'now=$now, tz.local=${tz.local.name}');

    for (final habit in habits) {
      final habitId = habit.id;
      final minutes = habit.reminderMinutes;
      if (!habit.reminderEnabled || habitId == null || minutes == null) {
        continue;
      }
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      final displayName = localizedHabitNameFromL10n(l10n, habit.name);
      final actions = habit.type == HabitType.YES_NO
          ? <AndroidNotificationAction>[
              AndroidNotificationAction('yes', l10n.notificationYes,
                  cancelNotification: true),
              AndroidNotificationAction('no', l10n.notificationNo,
                  cancelNotification: true),
            ]
          : null;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _kHabitReminderChannelId,
          _kHabitReminderChannelName,
          channelDescription: 'Reminders for your habits',
          importance: Importance.high,
          priority: Priority.high,
          playSound: false,
          enableVibration: true,
          actions: actions,
        ),
      );
      final payload = '$_kHabitReminderPayloadPrefix$habitId';
      final occurrences =
          _habitReminderOccurrences(habit, now, hour, minute);

      for (final occurrence in occurrences) {
        try {
          await plugin.zonedSchedule(
            id: _habitReminderId(habitId, occurrence.slot),
            title: l10n.notificationHabitReminderTitle,
            body: l10n.notificationHabitReminderBody(displayName),
            scheduledDate: occurrence.date,
            notificationDetails: details,
            androidScheduleMode: scheduleMode,
            matchDateTimeComponents: occurrence.repeat,
            payload: payload,
          );
          _log('Habit "$displayName" reminder scheduled for '
              '${occurrence.date} (repeat=${occurrence.repeat}, '
              'id=${_habitReminderId(habitId, occurrence.slot)})');
        } catch (e) {
          _log('Habit "$displayName" reminder schedule FAILED: $e');
        }
      }
    }
  }

  static int _habitReminderId(int habitId, int slot) =>
      _kHabitReminderIdBase + habitId * _kHabitReminderIdStride + slot;

  // Builds the future reminder slots for one habit. Daily and weekly-count
  // habits repeat every day; weekday habits repeat weekly on each selected
  // day; interval habits expose their next occurrences, because Android's
  // local notifications can only repeat daily or weekly, not every N days.
  static List<_HabitReminderOccurrence> _habitReminderOccurrences(
    Habit habit,
    tz.TZDateTime now,
    int hour,
    int minute,
  ) {
    if (habit.habitDays == HabitDays.DAYS_OF_WEEK) {
      final weekdays = (habit.habitPeriod ?? const <int>[])
          .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
          .toSet()
          .toList()
        ..sort();
      return <_HabitReminderOccurrence>[
        for (var slot = 0; slot < weekdays.length; slot++)
          _HabitReminderOccurrence(
            slot: slot,
            date: _nextWeekdayOccurrence(now, weekdays[slot], hour, minute),
            repeat: DateTimeComponents.dayOfWeekAndTime,
          ),
      ];
    }

    if (habit.habitDays == HabitDays.REPEATING) {
      final interval = habit.habitPeriod?.first ?? 1;
      final period = interval > 0 ? interval : 1;
      final created = DateTime(
        habit.createdTime.year,
        habit.createdTime.month,
        habit.createdTime.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final elapsed = today.difference(created).inDays;
      var daysUntilNext = (period - (elapsed % period)) % period;
      var date = DateTime(today.year, today.month, today.day + daysUntilNext);
      var scheduled = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
      if (daysUntilNext == 0 && !scheduled.isAfter(now)) {
        date = DateTime(date.year, date.month, date.day + period);
        scheduled = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
      }
      return <_HabitReminderOccurrence>[
        for (var slot = 0; slot < _kRepeatingReminderHorizon; slot++)
          _HabitReminderOccurrence(
            slot: slot,
            date: _datePlusDays(scheduled, date, slot * period, hour, minute),
          ),
      ];
    }

    // EVERYDAY and TIMES_PER_WEEK habits can be logged on any day, so they
    // keep a single daily repeating reminder.
    return <_HabitReminderOccurrence>[
      _HabitReminderOccurrence(
        slot: 0,
        date: _nextDailyOccurrence(now, hour, minute),
        repeat: DateTimeComponents.time,
      ),
    ];
  }

  static tz.TZDateTime _datePlusDays(
    tz.TZDateTime base,
    DateTime baseDate,
    int days,
    int hour,
    int minute,
  ) {
    if (days == 0) return base;
    final date = DateTime(baseDate.year, baseDate.month, baseDate.day + days);
    return tz.TZDateTime(tz.local, date.year, date.month, date.day, hour,
        minute);
  }

  static tz.TZDateTime _nextDailyOccurrence(
    tz.TZDateTime now,
    int hour,
    int minute,
  ) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }
    return scheduled;
  }

  static tz.TZDateTime _nextWeekdayOccurrence(
    tz.TZDateTime now,
    int weekday,
    int hour,
    int minute,
  ) {
    final daysAhead = (weekday - now.weekday) % 7;
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysAhead,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        scheduled.year,
        scheduled.month,
        scheduled.day + 7,
        hour,
        minute,
      );
    }
    return scheduled;
  }

  static Future<void> cancelHabitReminder(int habitId) async {
    for (var slot = 0; slot < _kHabitReminderIdStride; slot++) {
      await _notificationsPlugin.cancel(id: _habitReminderId(habitId, slot));
    }
  }

  static Future<void> sendTestNotification() async {
    final l10n = await _currentLocalizations();
    await _notificationsPlugin.show(
      id: 99,
      title: l10n.notificationReminderTitle,
      body: l10n.notificationReminderBody(_localizedPrayerName(l10n, 0)),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannelId,
          _kChannelName,
          channelDescription: 'Reminders to log your prayer habits',
          importance: Importance.high,
          priority: Priority.high,
          playSound: false,
          enableVibration: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('yes', l10n.notificationYes,
                cancelNotification: true),
            AndroidNotificationAction('no', l10n.notificationNo,
                cancelNotification: true),
          ],
        ),
      ),
      // A distinct payload (not a real prayer name) so _applyResponse
      // dismisses this like any other reminder but never writes to a
      // habit — this button is just for checking that notifications/
      // actions work, not a real "did you pray" prompt.
      payload: _kTestReminderPayload,
    );
  }

  // Plays the given voice directly through an in-app audio player, so
  // Settings can let the user preview a voice (honoring the current
  // Takbeer-only toggle) before saving it — without posting a system
  // notification, which would be pointless noise during a quick preview.
  static final AudioPlayer _testPlayer = AudioPlayer();

  static Future<void> playTestAdhan(AdhanVoiceOption voice) async {
    final takbeerOnly = PrayerSettings.adhanTakbeerOnly;
    final asset = takbeerOnly ? voice.takbeerAsset : voice.fullAsset;
    await _testPlayer.stop();
    await _testPlayer.play(AssetSource(asset.replaceFirst('assets/', '')));
  }

  static Future<void> stopTestAdhan() async {
    await _testPlayer.stop();
  }

  // Fires once the test playback finishes on its own (not via stopTestAdhan),
  // so the Settings screen can flip its button back to "play".
  static Stream<void> get onTestAdhanComplete => _testPlayer.onPlayerComplete;
}

@pragma('vm:entry-point')
void _handleBackgroundResponse(NotificationResponse response) {
  // This callback runs in a fresh background isolate that doesn't have the
  // Flutter plugin registrant set up automatically. Without this,
  // path_provider (used to locate demo.db) throws MissingPluginException and
  // the Yes/No answer is never written.
  _isBackgroundResponse = true;
  DartPluginRegistrant.ensureInitialized();
  _applyResponse(response);
}

void _handleResponse(NotificationResponse response) {
  _applyResponse(response);
}

void _applyResponse(NotificationResponse response) async {
  final payload = response.payload;
  final actionId = response.actionId;
  _log('Notification response: actionId=$actionId, payload=$payload');
  if (payload == null) return;
  if (actionId == null || (actionId != 'yes' && actionId != 'no')) return;

  // The "Send a test reminder now" button in Settings reuses this same
  // Yes/No flow so the notification itself can be tested, but it isn't a
  // real "did you pray" prompt — it must not touch actual habit data.
  if (payload == _kTestReminderPayload) {
    _log('Test reminder response: dismissing without recording');
    if (response.id != null) {
      await _notificationsPlugin.cancel(id: response.id!);
    }
    return;
  }

  // Per-habit reminder responses use their own payload prefix and write to
  // the habit with that database id, rather than looking a prayer up by
  // name. Only YES_NO habits include the Yes/No actions.
  if (payload.startsWith(_kHabitReminderPayloadPrefix)) {
    final habitId = int.tryParse(
        payload.substring(_kHabitReminderPayloadPrefix.length));
    if (habitId == null) {
      _log('Invalid habit reminder payload: $payload');
      return;
    }
    if (_isBackgroundResponse) {
      final port = IsolateNameServer.lookupPortByName(_kHabitUpdatePortName);
      if (port != null) {
        port.send(<String, dynamic>{
          'type': 'habit',
          'habitId': habitId,
          'actionId': actionId,
        });
        _log('Forwarded $actionId for habit $habitId to UI isolate');
        if (response.id != null) {
          await _notificationsPlugin.cancel(id: response.id!);
        }
        return;
      }
    }
    final recorded =
        await _recordHabitReminderResponse(habitId, actionId);
    if (recorded && !_isBackgroundResponse) {
      NotificationService.habitDataRevision.value++;
    }
    if (response.id != null) {
      await _notificationsPlugin.cancel(id: response.id!);
    }
    return;
  }

  final prayerName = payload;

  // A background-isolate action can't safely write the Sembast database
  // while the UI isolate is alive: the UI isolate keeps its own in-memory
  // database instance, so the file would change underneath it and its
  // reload would still serve the old cached value. Hand the answer to the
  // UI isolate when it's listening; only write here when the app isn't
  // running (the next cold start then reads the file from scratch).
  if (_isBackgroundResponse) {
    final port = IsolateNameServer.lookupPortByName(_kHabitUpdatePortName);
    if (port != null) {
      port.send(<String, dynamic>{
        'type': 'prayer',
        'prayerName': prayerName,
        'actionId': actionId,
      });
      _log('Forwarded $actionId for "$prayerName" to UI isolate');
      if (response.id != null) {
        await _notificationsPlugin.cancel(id: response.id!);
      }
      return;
    }
  }

  final recorded = await _recordHabitResponse(prayerName, actionId);
  if (recorded && !_isBackgroundResponse) {
    NotificationService.habitDataRevision.value++;
  }

  // The action itself is already set to auto-dismiss (cancelNotification:
  // true), but cancel explicitly too as a safety net in case that platform
  // behavior is ever unavailable.
  if (response.id != null) {
    await _notificationsPlugin.cancel(id: response.id!);
  }
}

Future<bool> _recordHabitReminderResponse(int habitId, String actionId) async {
  final dao = HabitDao();
  final habits = await dao.getAll();
  Habit? habit;
  for (final h in habits) {
    if (h.id == habitId) {
      habit = h;
      break;
    }
  }
  if (habit == null) {
    _log('No habit with id $habitId found — response not recorded');
    return false;
  }
  habit.setHabitDataValue(DateTime.now(), actionId == 'yes' ? 1 : 0);
  await dao.updateHabit(habit);
  _log('Recorded $actionId for habit "${habit.name}" '
      '(background=$_isBackgroundResponse)');
  return true;
}

Future<bool> _recordHabitResponse(String prayerName, String actionId) async {
  final dao = HabitDao();
  final habits = await dao.getAll();
  final habitName = '$prayerName Prayer';
  Habit? habit;
  for (final h in habits) {
    if (h.name == habitName) {
      habit = h;
      break;
    }
  }
  if (habit == null) {
    _log('No habit named "$habitName" found — response not recorded');
    return false;
  }
  habit.setHabitDataValue(DateTime.now(), actionId == 'yes' ? 1 : 0);
  // setHabitDataValue only mutates this in-memory Habit; without this it
  // was silently lost — nothing ever wrote the Yes/No answer back to the
  // database, so the habit's data never actually changed.
  await dao.updateHabit(habit);
  _log('Recorded $actionId for "$habitName" '
      '(background=$_isBackgroundResponse)');
  return true;
}
