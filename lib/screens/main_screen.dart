import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/today_overview.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainScreen extends StatefulWidget {
  final List<Habit> islamicHabits;
  const MainScreen({super.key, required this.islamicHabits});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late HijriCalendar hijriToday;
  DateTime today = DateTime.now();
  final prayerHelper = PrayerHelper.fromSettings();

  @override
  void initState() {
    super.initState();
    hijriToday = HijriCalendar.fromDate(today);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      drawer: HabitDrawer(
        habits: widget.islamicHabits,
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  localizedPrayerDisplayName(
                                      context, prayerHelper.getLaterPrayerName()),
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
                                        prayerHelper.getLaterPrayerTime())),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TodayOverview(habits: widget.islamicHabits),
          ],
        ),
      ),
    );
  }
}
