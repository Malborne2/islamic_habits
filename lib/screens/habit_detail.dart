import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/habit_page.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HabitDetail extends StatefulWidget {
  final Habit habit;
  final List<Habit> habits;
  const HabitDetail({super.key, required this.habit, required this.habits});
  @override
  _HabitDetailState createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  late PageController controller;
  DateTime currentDate =
      addDays(DateTime.now(), -(DateTime.now().day - 1));

  List<HabitPage> habitPages = [];
  late HijriCalendar hijriFirstDay;
  late HijriCalendar hijriLastDay;

  @override
  void initState() {
    hijriFirstDay = HijriCalendar.fromDate(currentDate);
    hijriLastDay = HijriCalendar.fromDate(
        addDays(currentDate, daysOfMonth(currentDate)));
    controller = PageController(
        initialPage: (12 * (currentDate.year - 1971) + currentDate.month) - 1);
    DateTime date = DateTime(1971, 1);
    habitPages = List.generate(
        (12 * (currentDate.year - 1971) + currentDate.month + 1), (i) {
      HabitPage myPage = HabitPage(
        habit: widget.habit,
        currentDate: date,
        onChanged: () => setState(() {}),
      );
      date = addDays(
          date, daysOfMonth(DateTime(1971 + (i ~/ 12), 1 + i % 12)));
      return myPage;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    // The streak target isn't shown as its own row any more — it's folded
    // into the current-streak value as "3/40" instead, since a lone
    // progress bar for a fixed goal number didn't read as a stat.
    final metricNames = [
      l10n.metricCurrentStreak,
      l10n.metricMaximumStreak,
      l10n.metricSuccessPercentage,
      l10n.metricWeeklyAverage,
      l10n.metricMonthlyAverage,
    ];
    final currentStreak = widget.habit.getCurrentStreak();
    final overallSuccessRate = widget.habit.getOverallSuccessRate();
    final weeklyAverage = widget.habit.getAverageOverPeriod(7);
    final monthlyAverage = widget.habit.getAverageOverPeriod(30);
    final isNumberHabit = widget.habit.type == HabitType.NUMBER;
    final target = widget.habit.successTarget > 0
        ? widget.habit.successTarget
        : 1;

    List<String> metricValues = [
      '$currentStreak/$target',
      widget.habit.getMaximumStreak().toString(),
      '${overallSuccessRate.toStringAsFixed(0)}%',
      isNumberHabit
          ? '${weeklyAverage.toStringAsFixed(1)} ${localizedUnit(context, widget.habit.numberUnit)}'
          : '${weeklyAverage.toStringAsFixed(0)}%',
      isNumberHabit
          ? '${monthlyAverage.toStringAsFixed(1)} ${localizedUnit(context, widget.habit.numberUnit)}'
          : '${monthlyAverage.toStringAsFixed(0)}%',
    ];
    const metricIcons = <IconData>[
      Icons.local_fire_department,
      Icons.emoji_events,
      Icons.pie_chart,
      Icons.calendar_view_week,
      Icons.calendar_month,
    ];
    final metricFractions = <double>[
      currentStreak / target,
      widget.habit.getMaximumStreak() / target,
      overallSuccessRate / 100,
      isNumberHabit ? weeklyAverage / target : weeklyAverage / 100,
      isNumberHabit ? monthlyAverage / target : monthlyAverage / 100,
    ];

    final isBuiltInPrayerHabit = kPrayersNames
        .map((name) => '$name Prayer')
        .contains(widget.habit.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedHabitName(context, widget.habit.name)),
        backgroundColor: widget.habit.color,
        actions: <Widget>[
          if (!isBuiltInPrayerHabit)
            IconButton(
              tooltip: l10n.editHabitAction,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                await Navigator.push<Habit>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddHabitScreen(editingHabit: widget.habit),
                  ),
                );
                if (mounted) setState(() {});
              },
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                currentStreak.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 30),
                child: Text(
                  '${overallSuccessRate.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Material(
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      controller.previousPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                    });
                  },
                ),
                title: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Center(
                        child: Text(
                      localizeDigits(context,
                          DateFormat('MMMM yyyy', locale).format(currentDate)),
                      style: const TextStyle(fontSize: 20),
                    )),
                  ),
                  subtitle: Center(
                    child: AutoSizeText(
                      localizeDigits(
                          context,
                          hijriFirstDay.toFormat("MMMM yyyy") ==
                                  hijriLastDay.toFormat("MMMM yyyy")
                              ? hijriFirstDay.toFormat("MMMM yyyy")
                              : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}'),
                      style: const TextStyle(fontSize: 18.0),
                      maxLines: 1,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      controller.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease);
                    });
                  },
                ),
              ),
            ),
          ),
          // A fixed height derived from the grid's own geometry (7 columns,
          // up to 6 rows) rather than Expanded, so the calendar never
          // leaves dead space below a short month, and the stats section
          // below always starts right where the calendar actually ends.
          SizedBox(
            height: _calendarHeight(context),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  if (index > controller.page!.floor()) {
                    currentDate =
                        addDays(currentDate, daysOfMonth(currentDate));

                    if (index == habitPages.length - 1) {
                      habitPages.add(HabitPage(
                        habit: widget.habit,
                        currentDate:
                            addDays(currentDate, daysOfMonth(currentDate)),
                        onChanged: () => setState(() {}),
                      ));
                    }
                  } else {
                    currentDate = addDays(currentDate,
                        -daysOfMonth(addDays(currentDate, -1)));
                  }

                  hijriFirstDay = HijriCalendar.fromDate(currentDate);
                  hijriLastDay = HijriCalendar.fromDate(
                      addDays(currentDate, daysOfMonth(currentDate)));
                });
              },
              children: habitPages,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: List.generate(
                  metricNames.length,
                  (i) => _StatBarRow(
                    icon: metricIcons[i],
                    value: metricValues[i],
                    fraction: metricFractions[i],
                    label: metricNames[i],
                    color: widget.habit.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mirrors ButtonsList' own grid math (7 columns, cells 0.8x the column
  // width, Wrap's runSpacing of 5) to size the calendar to exactly 6 rows —
  // the most any month needs — so every month renders at the same height
  // with nothing left over beneath it.
  double _calendarHeight(BuildContext context) {
    final columnWidth = MediaQuery.of(context).size.width / 7;
    final diameter = columnWidth * 0.8;
    const weekdayHeaderHeight = 48.0;
    const rowSpacing = 5.0;
    const maxRows = 6;
    return weekdayHeaderHeight + maxRows * diameter + (maxRows - 1) * rowSpacing;
  }
}

// One stat as a labelled horizontal bar instead of a plain number in a
// table — the fill length gives an at-a-glance sense of progress that a
// bare figure doesn't.
class _StatBarRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final double fraction;
  final String label;
  final Color color;
  const _StatBarRow({
    required this.icon,
    required this.value,
    required this.fraction,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(label, style: const TextStyle(fontSize: 12.5)),
                    Text(value,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: color.withValues(alpha: 0.14),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
