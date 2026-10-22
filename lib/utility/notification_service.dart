import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
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
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    // Without this, tz.local silently stays UTC, so every zonedSchedule
    // below computes the wrong wall-clock instant — in most timezones that
    // instant is already in the past by the time it's scheduled, so the
    // notification is just dropped, which is why reminders never fired
    // despite scheduling appearing to succeed.
    try {
      final deviceTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTimeZone));
      _log('Resolved device timezone: $deviceTimeZone (tz.local=${tz.local.name})');
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
    await ensureAdhanChannelMatchesSettings();
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

  static Future<void> cancelAllPrayerReminders() async {
    for (int i = 0; i < kPrayersNames.length; i++) {
      await _notificationsPlugin.cancel(id: i);
      await _notificationsPlugin.cancel(id: 10 + i);
    }
  }

  // Schedules today's remaining prayers according to each prayer's mode:
  // silent (nothing), notify (a Yes/No reminder 30 minutes later), or
  // adhan (a sound-only notification right at the prayer time). Adhan mode
  // always schedules regardless of PrayerSettings.remindersEnabled — that
  // switch's own label only describes the 30-minutes-later Yes/No
  // reminder, so it must not also silently block Adhan notifications,
  // which the user enables per-prayer via the speaker icon. Called
  // whenever the app starts/resumes; there is no background job to
  // reschedule the next day on its own.
  static Future<void> scheduleTodayReminders() async {
    await cancelAllPrayerReminders();

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
      if (mode == PrayerNotifyMode.silent) {
        _log('  [$i] ${kPrayersNames[i]}: silent, skipped');
        continue;
      }
      // The payload stays the canonical English key so it always matches
      // the stored habit name, regardless of display language.
      final habitPrayerName = kPrayersNames[i];
      final displayName = _localizedPrayerName(l10n, i);

      if (mode == PrayerNotifyMode.adhan) {
        if (prayerTimes[i].isBefore(now)) {
          _log('  [$i] ${kPrayersNames[i]}: adhan time ${prayerTimes[i]} '
              'already passed, skipped');
          continue;
        }
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
        continue;
      }

      if (!PrayerSettings.remindersEnabled) {
        _log('  [$i] ${kPrayersNames[i]}: notify reminders disabled, skipped');
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
            // The plain bell mode is meant to be vibration-only, as opposed
            // to the speaker (adhan) mode which plays a reciter's voice.
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
  _applyResponse(response);
}

void _handleResponse(NotificationResponse response) {
  _applyResponse(response);
}

void _applyResponse(NotificationResponse response) async {
  final prayerName = response.payload;
  _log('Notification response: actionId=${response.actionId}, '
      'payload=$prayerName');
  if (prayerName == null) return;
  if (response.actionId != 'yes' && response.actionId != 'no') return;

  // The "Send a test reminder now" button in Settings reuses this same
  // Yes/No flow so the notification itself can be tested, but it isn't a
  // real "did you pray" prompt — it must not touch actual habit data.
  if (prayerName == _kTestReminderPayload) {
    _log('Test reminder response: dismissing without recording');
    if (response.id != null) {
      await _notificationsPlugin.cancel(id: response.id!);
    }
    return;
  }

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
    return;
  }
  habit.setHabitDataValue(DateTime.now(), response.actionId == 'yes' ? 1 : 0);
  // setHabitDataValue only mutates this in-memory Habit; without this it
  // was silently lost — nothing ever wrote the Yes/No answer back to the
  // database, so the habit's data never actually changed.
  await dao.updateHabit(habit);
  _log('Recorded ${response.actionId} for "$habitName"');

  // The action itself is already set to auto-dismiss (cancelNotification:
  // true), but cancel explicitly too as a safety net in case that platform
  // behavior is ever unavailable.
  if (response.id != null) {
    await _notificationsPlugin.cancel(id: response.id!);
  }
}
