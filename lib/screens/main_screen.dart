import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/today_overview.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/statistics_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/route_observer.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainScreen extends StatefulWidget {
  final List<Habit> islamicHabits;
  const MainScreen({super.key, required this.islamicHabits});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with RouteAware, WidgetsBindingObserver {
  late HijriCalendar hijriToday;
  DateTime today = DateTime.now();
  Timer? _countdownTimer;
  late List<Habit> _habits;
  // Guards against an older getAll() finishing after a newer one and
  // overwriting fresher data.
  int _reloadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _habits = widget.islamicHabits;
    hijriToday = HijriCalendar.fromDate(today);
    NotificationService.habitDataRevision.addListener(_onHabitDataChanged);
    // Ticks the next-prayer countdown and lets it roll over to the
    // following prayer on its own once the current one's time passes.
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    NotificationService.habitDataRevision.removeListener(_onHabitDataChanged);
    appRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onHabitDataChanged() {
    debugPrint('[MainScreen] habit data changed, reloading from database');
    _reloadHabits();
  }

  // Replaces the in-memory list with what's actually in the database. The
  // notification's Yes/No action writes Habit data directly, and this screen
  // used to keep the list it was first constructed with forever, so the
  // change only appeared after a full app restart.
  Future<void> _reloadHabits() async {
    final generation = ++_reloadGeneration;
    final habits = await HabitDao().getActive();
    if (!mounted || generation != _reloadGeneration) return;
    Habit? fajr;
    for (final h in habits) {
      if (h.name == 'Al Fajir Prayer') {
        fajr = h;
        break;
      }
    }
    debugPrint('[MainScreen] reloaded ${habits.length} habits; '
        'Fajir today=${fajr?.getHabitDataValue(DateTime.now())}');
    setState(() {
      _habits = habits;
    });
  }

  // scheduleTodayReminders() only schedules the CURRENT day's remaining
  // prayers; without this, an app left running overnight (never cold
  // started again) would never get the next day's reminders/Adhan
  // scheduled at all.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (now.year != today.year ||
          now.month != today.month ||
          now.day != today.day) {
        setState(() {
          today = now;
          hijriToday = HijriCalendar.fromDate(today);
        });
      }
      _reloadHabits();
      // A Yes/No handled in the background isolate may still be finishing its
      // database write when the app is brought back to the foreground, so
      // check once more shortly afterwards.
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _reloadHabits();
      });
      NotificationService.scheduleTodayReminders();
      // Habit reminders repeat daily, but rescheduling on resume keeps them
      // correct after a timezone change, a language change (the notification
      // text is localized at schedule time), or a habit edit.
      NotificationService.scheduleHabitReminders();
    }
  }

  // Called when a route pushed on top of this screen (e.g. Settings) is
  // popped back to it, so prayer time corrections made there show up
  // immediately instead of needing an unrelated navigation first.
  @override
  void didPopNext() {
    setState(() {});
    _reloadHabits();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    final prayerHelper = PrayerHelper.fromSettings();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.navStatistics,
            icon: const Icon(Icons.insights_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(habits: _habits),
                  settings: const RouteSettings(name: '/StatisticsScreen'),
                ),
              );
            },
          ),
        ],
      ),
      drawer: HabitDrawer(
        habits: _habits,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ListView(
          children: <Widget>[
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: AutoSizeText(
                                    localizeDigits(context,
                                        hijriToday.toFormat("DDDD, d MMMM yyyy")),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Center(
                                child: AutoSizeText(
                                  localizeDigits(
                                      context,
                                      DateFormat('MMMM d yyyy', locale)
                                          .format(today)),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 2,
                            indent: 2,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: AutoSizeText(
                                  localizedPrayerDisplayName(
                                      context, prayerHelper.getNextPrayerName()),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              AutoSizeText(
                                localizeDigits(
                                    context,
                                    DateFormat.jm(locale).format(
                                        prayerHelper.getNextPrayerTime())),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              _CountdownBadge(
                                remaining: prayerHelper
                                    .getNextPrayerTime()
                                    .difference(DateTime.now()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TodayOverview(habits: _habits),
          ],
        ),
      ),
    );
  }
}

// A small pill showing how long until the next prayer, e.g. "in 2h 14m" or
// "in 42m" once under an hour. Clamped to zero so a prayer time that's just
// passed (before the next build picks the following prayer) never shows a
// negative countdown.
class _CountdownBadge extends StatelessWidget {
  final Duration remaining;
  const _CountdownBadge({required this.remaining});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clamped = remaining.isNegative ? Duration.zero : remaining;
    final hours = clamped.inHours;
    final minutes = clamped.inMinutes % 60;
    final text = hours > 0
        ? l10n.nextPrayerCountdownHm(hours, minutes)
        : l10n.nextPrayerCountdownM(minutes);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: brandAccent(context).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AutoSizeText(
        localizeDigits(context, text),
        maxLines: 1,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: brandAccent(context)),
      ),
    );
  }
}
