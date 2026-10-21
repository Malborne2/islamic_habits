import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

const String _kChannelId = 'prayer_reminders';
const String _kChannelName = 'Prayer reminders';

// Separate channels per voice: once created, a notification channel's
// sound can't be changed, so switching voices needs a different channel.
const String _kTakbeerChannelId = 'prayer_adhan_takbeer';
const String _kFullAdhanChannelId = 'prayer_adhan_full';

// Place your own licensed audio at android/app/src/main/res/raw/takbeer.mp3
// and android/app/src/main/res/raw/adhan_full.mp3 for these to actually
// play; without them Android silently falls back to the default sound.
const String _kTakbeerSoundResource = 'takbeer';
const String _kFullAdhanSoundResource = 'adhan_full';

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Reminders fire 30 minutes after each prayer's calculated time, asking
// whether the prayer was performed; answering Yes/No marks that habit's
// data for today directly, without opening the app.
class NotificationService {
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse: _handleBackgroundResponse,
    );
  }

  static Future<bool> requestPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestNotificationsPermission();
    return granted ?? false;
  }

  static Future<void> cancelAllPrayerReminders() async {
    for (int i = 0; i < kPrayersNames.length; i++) {
      await _notificationsPlugin.cancel(id: i);
      await _notificationsPlugin.cancel(id: 10 + i);
    }
  }

  // Schedules today's remaining prayers according to each prayer's mode:
  // silent (nothing), notify (a Yes/No reminder 30 minutes later), or
  // adhan (a sound-only notification right at the prayer time). Called
  // whenever the app starts/resumes and reminders are enabled; there is
  // no background job to reschedule the next day on its own.
  static Future<void> scheduleTodayReminders() async {
    await cancelAllPrayerReminders();
    if (!PrayerSettings.remindersEnabled) return;

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
      if (mode == PrayerNotifyMode.silent) continue;
      final prayerName = kPrayersNames[i];

      if (mode == PrayerNotifyMode.adhan) {
        if (prayerTimes[i].isBefore(now)) continue;
        final isTakbeer = PrayerSettings.adhanVoice == AdhanVoice.takbeer;
        await _notificationsPlugin.zonedSchedule(
          id: 10 + i,
          title: 'Prayer time',
          body: 'It is time for $prayerName',
          scheduledDate: tz.TZDateTime.from(prayerTimes[i], tz.local),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              isTakbeer ? _kTakbeerChannelId : _kFullAdhanChannelId,
              isTakbeer ? 'Adhan (Takbeer)' : 'Adhan (Full)',
              channelDescription: 'Plays the adhan at prayer time',
              importance: Importance.high,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound(isTakbeer
                  ? _kTakbeerSoundResource
                  : _kFullAdhanSoundResource),
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        continue;
      }

      final reminderTime = prayerTimes[i].add(const Duration(minutes: 30));
      if (reminderTime.isBefore(now)) continue;
      await _notificationsPlugin.zonedSchedule(
        id: i,
        title: 'Prayer reminder',
        body: 'Did you pray $prayerName?',
        scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _kChannelId,
            _kChannelName,
            channelDescription: 'Reminders to log your prayer habits',
            importance: Importance.high,
            priority: Priority.high,
            actions: const <AndroidNotificationAction>[
              AndroidNotificationAction('yes', 'Yes'),
              AndroidNotificationAction('no', 'No'),
            ],
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: prayerName,
      );
    }
  }

  static Future<void> sendTestNotification() async {
    await _notificationsPlugin.show(
      id: 99,
      title: 'Prayer reminder',
      body: 'Did you pray Fajr?',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannelId,
          _kChannelName,
          channelDescription: 'Reminders to log your prayer habits',
          importance: Importance.high,
          priority: Priority.high,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('yes', 'Yes'),
            AndroidNotificationAction('no', 'No'),
          ],
        ),
      ),
      payload: 'Al Fajir',
    );
  }
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
  if (prayerName == null) return;
  if (response.actionId != 'yes' && response.actionId != 'no') return;

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
  if (habit == null) return;
  habit.setHabitDataValue(DateTime.now(), response.actionId == 'yes' ? 1 : 0);
}
