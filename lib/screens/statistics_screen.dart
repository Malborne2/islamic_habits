import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/components/habit_button.dart' show Status;
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';

/// A professional, scrollable overview of every habit: a headline success
/// rate, a 30-day completion trend, weekly and monthly averages, a
/// success/missed/no-data breakdown, and a per-habit performance list.
///
/// It reloads from the database whenever a notification action writes habit
/// data, so the charts stay correct while the screen is open.
class StatisticsScreen extends StatefulWidget {
  final List<Habit> habits;
  const StatisticsScreen({super.key, required this.habits});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late List<Habit> _habits;

  @override
  void initState() {
    super.initState();
    _habits = List<Habit>.of(widget.habits);
    NotificationService.habitDataRevision.addListener(_onHabitDataChanged);
    _reload();
  }

  @override
  void dispose() {
    NotificationService.habitDataRevision.removeListener(_onHabitDataChanged);
    super.dispose();
  }

  void _onHabitDataChanged() {
    _reload();
  }

  Future<void> _reload() async {
    final habits = await HabitDao().getActive();
    if (!mounted) return;
    setState(() => _habits = habits);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = _StatsPalette.of(context);
    final accent = palette.overall;
    final data = _StatisticsData.compute(_habits);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navStatistics),
      ),
      body: _habits.isEmpty
          ? _EmptyState(
              accent: accent,
              title: l10n.statisticsNoDataTitle,
              body: l10n.statisticsNoDataBody,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: <Widget>[
                _OverviewCard(data: data, palette: palette),
                const SizedBox(height: 14),
                if (!data.hasData)
                  _EmptyStateCard(
                    accent: accent,
                    title: l10n.statisticsNoDataTitle,
                    body: l10n.statisticsNoDataBody,
                  )
                else ...<Widget>[
                  _DailyCompletionCard(
                    data: data,
                    accent: palette.daily,
                    gridColor: theme.dividerColor,
                  ),
                  const SizedBox(height: 14),
                  _WeeklyProgressCard(
                    data: data,
                    accent: palette.weekly,
                    gridColor: theme.dividerColor,
                  ),
                  const SizedBox(height: 14),
                  _MonthlyProgressCard(
                    data: data,
                    accent: palette.monthly,
                    gridColor: theme.dividerColor,
                  ),
                  const SizedBox(height: 14),
                  _BreakdownCard(data: data, accent: accent),
                  const SizedBox(height: 22),
                  Text(
                    l10n.statisticsHabitPerformance,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._habits.map(
                    (habit) => _HabitPerformanceCard(
                      habit: habit,
                      accent: accent,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _StatisticsData {
  final int totalHabits;
  final int todayCompleted;
  final int todayTotal;
  final double overallSuccess;
  final int bestStreak;
  final bool hasData;
  final List<_DayCompletion> daily;
  final List<_PeriodCompletion> weekly;
  final List<_PeriodCompletion> monthly;
  final int successHabitDays;
  final int missedHabitDays;
  final int noDataHabitDays;

  const _StatisticsData({
    required this.totalHabits,
    required this.todayCompleted,
    required this.todayTotal,
    required this.overallSuccess,
    required this.bestStreak,
    required this.hasData,
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.successHabitDays,
    required this.missedHabitDays,
    required this.noDataHabitDays,
  });

  factory _StatisticsData.compute(List<Habit> habits) {
    final today = _dateOnly(DateTime.now());
    final earliest = <Habit, DateTime>{
      for (final habit in habits) habit: _earliestTrackedDay(habit),
    };

    // Today's progress.
    int todayCompleted = 0;
    int todayTotal = 0;
    for (final habit in habits) {
      if (!_isActiveOn(habit, today, today, earliest)) continue;
      todayTotal++;
      if (habit.getStatus(today) == Status.SUCCESS) todayCompleted++;
    }

    // Overall success since each habit was created. Unlogged habit days count
    // as incomplete, matching the per-habit success percentage shown on the
    // habit detail screen.
    int totalHabitDays = 0;
    int successHabitDays = 0;
    for (final habit in habits) {
      DateTime day = earliest[habit]!;
      while (!day.isAfter(today)) {
        if (_isActiveOn(habit, day, today, earliest) &&
            !_isPendingToday(habit, day, today)) {
          totalHabitDays++;
          if (habit.getStatus(day) == Status.SUCCESS) successHabitDays++;
        }
        day = addDays(day, 1);
      }
    }
    final overallSuccess =
        totalHabitDays == 0 ? 0.0 : 100 * successHabitDays / totalHabitDays;

    // Longest streak across all habits.
    int bestStreak = 0;
    for (final habit in habits) {
      bestStreak = math.max(bestStreak, habit.getMaximumStreak());
    }

    // Daily completion for the last 30 days.
    final daily = <_DayCompletion>[
      for (int i = 29; i >= 0; i--)
        _dayCompletion(habits, addDays(today, -i), today, earliest),
    ];

    // Weekly averages for the last four calendar weeks.
    final weekly = <_PeriodCompletion>[];
    final currentWeekStart = _startOfWeek(today);
    for (int i = 3; i >= 0; i--) {
      final start = addDays(currentWeekStart, -7 * i);
      final end = addDays(start, 6);
      weekly.add(_periodCompletion(
        habits,
        start,
        end.isAfter(today) ? today : end,
        today,
        earliest,
      ));
    }

    // Monthly averages for the last six calendar months.
    final monthly = <_PeriodCompletion>[];
    final thisMonth = DateTime(today.year, today.month, 1);
    for (int i = 5; i >= 0; i--) {
      final start = DateTime(thisMonth.year, thisMonth.month - i, 1);
      final end = DateTime(start.year, start.month + 1, 0);
      monthly.add(_periodCompletion(
        habits,
        start,
        end.isAfter(today) ? today : end,
        today,
        earliest,
      ));
    }

    // Breakdown for the same 30-day window.
    int successDays = 0;
    int missedDays = 0;
    int noDataDays = 0;
    for (int i = 29; i >= 0; i--) {
      final day = addDays(today, -i);
      for (final habit in habits) {
        if (!_isActiveOn(habit, day, today, earliest)) continue;
        if (!habit.hasData(day)) {
          noDataDays++;
        } else if (habit.getStatus(day) == Status.SUCCESS) {
          successDays++;
        } else {
          missedDays++;
        }
      }
    }

    return _StatisticsData(
      totalHabits: habits.length,
      todayCompleted: todayCompleted,
      todayTotal: todayTotal,
      overallSuccess: overallSuccess,
      bestStreak: bestStreak,
      hasData: habits.any((habit) => habit.habitData.isNotEmpty),
      daily: daily,
      weekly: weekly,
      monthly: monthly,
      successHabitDays: successDays,
      missedHabitDays: missedDays,
      noDataHabitDays: noDataDays,
    );
  }
}

class _DayCompletion {
  final DateTime day;
  final int completed;
  final int total;
  final double percent;

  const _DayCompletion({
    required this.day,
    required this.completed,
    required this.total,
    required this.percent,
  });
}

class _PeriodCompletion {
  final DateTime start;
  final DateTime end;
  final double percent;

  const _PeriodCompletion({
    required this.start,
    required this.end,
    required this.percent,
  });
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _earliestTrackedDay(Habit habit) {
  DateTime earliest = _dateOnly(habit.createdTime);
  for (final key in habit.habitData.keys) {
    final parsed = DateTime.tryParse(key);
    if (parsed != null) {
      final day = _dateOnly(parsed);
      if (day.isBefore(earliest)) earliest = day;
    }
  }
  return earliest;
}

bool _isActiveOn(
  Habit habit,
  DateTime day,
  DateTime today,
  Map<Habit, DateTime> earliest,
) {
  return !day.isAfter(today) &&
      !day.isBefore(earliest[habit]!) &&
      habit.isHabitDay(day);
}

bool _isPendingToday(Habit habit, DateTime day, DateTime today) {
  return day == today && !habit.hasData(day);
}

_DayCompletion _dayCompletion(
  List<Habit> habits,
  DateTime day,
  DateTime today,
  Map<Habit, DateTime> earliest,
) {
  int completed = 0;
  int total = 0;
  for (final habit in habits) {
    if (!_isActiveOn(habit, day, today, earliest)) continue;
    // Don't penalise today's unlogged habits yet — the day isn't over.
    if (_isPendingToday(habit, day, today)) continue;
    total++;
    if (habit.getStatus(day) == Status.SUCCESS) completed++;
  }
  return _DayCompletion(
    day: day,
    completed: completed,
    total: total,
    percent: total == 0 ? 0 : 100 * completed / total,
  );
}

_PeriodCompletion _periodCompletion(
  List<Habit> habits,
  DateTime start,
  DateTime end,
  DateTime today,
  Map<Habit, DateTime> earliest,
) {
  double sum = 0;
  int countedDays = 0;
  DateTime day = start;
  while (!day.isAfter(end)) {
    final completion = _dayCompletion(habits, day, today, earliest);
    if (completion.total > 0) {
      sum += completion.percent;
      countedDays++;
    }
    day = addDays(day, 1);
  }
  return _PeriodCompletion(
    start: start,
    end: end,
    percent: countedDays == 0 ? 0 : sum / countedDays,
  );
}

DateTime _startOfWeek(DateTime day) {
  final start = Habit.startOfWeek.clamp(1, 7);
  final diff = (day.weekday - start) % 7;
  return addDays(_dateOnly(day), -diff);
}

// ---------------------------------------------------------------------------
// UI
// ---------------------------------------------------------------------------

// Each chart gets its own hue so the dashboard reads as a set of distinct
// stories instead of four shades of the brand colour. The overall card stays
// gold; the period cards step through blue, orange, and violet. Dark mode uses
// brighter variants so the lines and bars pop against the black surface.
class _StatsPalette {
  final Color overall;
  final Color daily;
  final Color weekly;
  final Color monthly;
  const _StatsPalette({
    required this.overall,
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  factory _StatsPalette.of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const _StatsPalette(
        overall: Color(0xFFE0B65C),
        daily: Color(0xFF38BDF8),
        weekly: Color(0xFFFB923C),
        monthly: Color(0xFFA78BFA),
      );
    }
    return const _StatsPalette(
      overall: Color(0xFFC9A24B),
      daily: Color(0xFF0284C7),
      weekly: Color(0xFFEA580C),
      monthly: Color(0xFF7C3AED),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final _StatisticsData data;
  final _StatsPalette palette;
  const _OverviewCard({required this.data, required this.palette});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final Color accent = palette.overall;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.statisticsOverallSuccess,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.statisticsOverallSuccessSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 94,
                  height: 94,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: (data.overallSuccess / 100).clamp(0.0, 1.0),
                          strokeWidth: 10,
                          strokeCap: StrokeCap.round,
                          backgroundColor: accent.withValues(alpha: 0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            localizeDigits(
                                context,
                                '${data.overallSuccess.toStringAsFixed(0)}%'),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: accent,
                            ),
                          ),
                          Text(
                            l10n.statisticsSuccess,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetricTile(
                    icon: Icons.today_rounded,
                    label: l10n.todayLabel,
                    value:
                        '${data.todayCompleted} / ${data.todayTotal}',
                    accent: palette.daily,
                  ),
                ),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.local_fire_department_rounded,
                    label: l10n.statisticsBestStreak,
                    value: l10n.streakDays(data.bestStreak),
                    accent: palette.weekly,
                  ),
                ),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.checklist_rounded,
                    label: l10n.statisticsTotalHabits,
                    value: '${data.totalHabits}',
                    accent: palette.monthly,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: accent),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            localizeDigits(context, value),
            maxLines: 1,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyCompletionCard extends StatelessWidget {
  final _StatisticsData data;
  final Color accent;
  final Color gridColor;
  const _DailyCompletionCard({
    required this.data,
    required this.accent,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final daily = data.daily;
    final spots = <FlSpot>[
      for (int i = 0; i < daily.length; i++)
        FlSpot(i.toDouble(), daily[i].percent),
    ];
    return _ChartCard(
      title: l10n.statisticsDailyCompletion,
      subtitle: l10n.statisticsDailyCompletionSubtitle,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (daily.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor.withValues(alpha: 0.45),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                reservedSize: 38,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    localizeDigits(context, '${value.toInt()}%'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= daily.length) {
                    return const SizedBox.shrink();
                  }
                  // Label every week plus the final day, so the axis stays
                  // readable on a narrow phone. Skip a weekly label when it
                  // would sit right next to the final "today" label.
                  final bool isLast = index == daily.length - 1;
                  final bool isWeekly = index == 0 ||
                      (index % 7 == 0 && daily.length - 1 - index > 2);
                  if (!isLast && !isWeekly) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                    child: Text(
                      localizeDigits(
                        context,
                        DateFormat('d MMM', locale).format(daily[index].day),
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => kBrandNavy,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final index = spot.x.round().clamp(0, daily.length - 1);
                final day = daily[index];
                return LineTooltipItem(
                  '${DateFormat('d MMM', locale).format(day.day)}\n'
                  '${localizeDigits(context, '${day.percent.toStringAsFixed(0)}%')}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.32,
              color: accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    accent.withValues(alpha: 0.28),
                    accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  final _StatisticsData data;
  final Color accent;
  final Color gridColor;
  const _WeeklyProgressCard({
    required this.data,
    required this.accent,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final weekly = data.weekly;
    return _ChartCard(
      title: l10n.statisticsWeeklyProgress,
      subtitle: l10n.statisticsWeeklyProgressSubtitle,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 100,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor.withValues(alpha: 0.45),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                reservedSize: 38,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    localizeDigits(context, '${value.toInt()}%'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= weekly.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      localizeDigits(
                        context,
                        DateFormat('d MMM', locale)
                            .format(weekly[index].start),
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => kBrandNavy,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = DateFormat('d MMM', locale)
                    .format(weekly[group.x].start);
                return BarTooltipItem(
                  '$label\n'
                  '${localizeDigits(context, '${rod.toY.toStringAsFixed(0)}%')}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          barGroups: <BarChartGroupData>[
            for (int i = 0; i < weekly.length; i++)
              BarChartGroupData(
                x: i,
                barRods: <BarChartRodData>[
                  BarChartRodData(
                    toY: weekly[i].percent,
                    width: 26,
                    borderRadius: BorderRadius.circular(7),
                    color: accent,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyProgressCard extends StatelessWidget {
  final _StatisticsData data;
  final Color accent;
  final Color gridColor;
  const _MonthlyProgressCard({
    required this.data,
    required this.accent,
    required this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final monthly = data.monthly;
    final spots = <FlSpot>[
      for (int i = 0; i < monthly.length; i++)
        FlSpot(i.toDouble(), monthly[i].percent),
    ];
    return _ChartCard(
      title: l10n.statisticsMonthlyProgress,
      subtitle: l10n.statisticsMonthlyProgressSubtitle,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (monthly.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: gridColor.withValues(alpha: 0.45),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                reservedSize: 38,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    localizeDigits(context, '${value.toInt()}%'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= monthly.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      localizeDigits(
                        context,
                        DateFormat('MMM', locale)
                            .format(monthly[index].start),
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => kBrandNavy,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final index = spot.x.round().clamp(0, monthly.length - 1);
                final period = monthly[index];
                return LineTooltipItem(
                  '${DateFormat('MMM yyyy', locale).format(period.start)}\n'
                  '${localizeDigits(context, '${period.percent.toStringAsFixed(0)}%')}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.28,
              color: accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: accent,
                  strokeWidth: 2,
                  strokeColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    accent.withValues(alpha: 0.22),
                    accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final _StatisticsData data;
  final Color accent;
  const _BreakdownCard({required this.data, required this.accent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final successColor = const Color(0xFF22C55E);
    final missedColor = const Color(0xFFEF4444);
    final noDataColor = theme.colorScheme.outlineVariant;
    final sections = <PieChartSectionData>[
      if (data.successHabitDays > 0)
        PieChartSectionData(
          value: data.successHabitDays.toDouble(),
          color: successColor,
          showTitle: false,
          radius: 28,
        ),
      if (data.missedHabitDays > 0)
        PieChartSectionData(
          value: data.missedHabitDays.toDouble(),
          color: missedColor,
          showTitle: false,
          radius: 28,
        ),
      if (data.noDataHabitDays > 0)
        PieChartSectionData(
          value: data.noDataHabitDays.toDouble(),
          color: noDataColor,
          showTitle: false,
          radius: 28,
        ),
    ];
    final total = data.successHabitDays +
        data.missedHabitDays +
        data.noDataHabitDays;

    return _ChartCard(
      title: l10n.statisticsBreakdown,
      subtitle: l10n.statisticsBreakdownSubtitle,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 148,
            height: 148,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (sections.isNotEmpty)
                  PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 42,
                      sectionsSpace: 3,
                      startDegreeOffset: -90,
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      localizeDigits(
                        context,
                        '${data.overallSuccess.toStringAsFixed(0)}%',
                      ),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                    Text(
                      l10n.statisticsSuccess,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: <Widget>[
                _LegendRow(
                  color: successColor,
                  label: l10n.statisticsSuccess,
                  value: data.successHabitDays,
                  total: total,
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: missedColor,
                  label: l10n.statisticsMissed,
                  value: data.missedHabitDays,
                  total: total,
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: noDataColor,
                  label: l10n.statisticsNoData,
                  value: data.noDataHabitDays,
                  total: total,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final int total;
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = total == 0 ? 0 : 100 * value / total;
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ),
        Text(
          localizeDigits(context, '${percent.toStringAsFixed(0)}%'),
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color == theme.colorScheme.outlineVariant
                ? theme.colorScheme.onSurfaceVariant
                : color,
          ),
        ),
      ],
    );
  }
}

class _HabitPerformanceCard extends StatelessWidget {
  final Habit habit;
  final Color accent;
  const _HabitPerformanceCard({required this.habit, required this.accent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isNumber = habit.type == HabitType.NUMBER;
    final successRate = habit.getOverallSuccessRate();
    final weekly = habit.getAverageOverPeriod(7);
    final monthly = habit.getAverageOverPeriod(30);
    final weeklyText = isNumber
        ? '${weekly.toStringAsFixed(1)} ${localizedUnit(context, habit.numberUnit)}'
        : '${weekly.toStringAsFixed(0)}%';
    final monthlyText = isNumber
        ? '${monthly.toStringAsFixed(1)} ${localizedUnit(context, habit.numberUnit)}'
        : '${monthly.toStringAsFixed(0)}%';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    habitIconForHabit(habit) ??
                        (isNumber ? Icons.numbers_rounded : Icons.check_rounded),
                    color: habit.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizedHabitName(context, habit.name),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  localizeDigits(
                    context,
                    '${successRate.toStringAsFixed(0)}%',
                  ),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: habit.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: LinearProgressIndicator(
                value: (successRate / 100).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: habit.color.withValues(alpha: 0.14),
                valueColor: AlwaysStoppedAnimation<Color>(habit.color),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MiniStat(
                    label: l10n.metricCurrentStreak,
                    value: l10n.streakDays(habit.getCurrentStreak()),
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: l10n.metricMaximumStreak,
                    value: l10n.streakDays(habit.getMaximumStreak()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: _MiniStat(
                    label: l10n.metricWeeklyAverage,
                    value: weeklyText,
                  ),
                ),
                Expanded(
                  child: _MiniStat(
                    label: l10n.metricMonthlyAverage,
                    value: monthlyText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            localizeDigits(context, value),
            maxLines: 1,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(height: 210, child: child),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final Color accent;
  final String title;
  final String body;
  const _EmptyStateCard({
    required this.accent,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.insights_rounded, size: 32, color: accent),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color accent;
  final String title;
  final String body;
  const _EmptyState({
    required this.accent,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: _EmptyStateCard(accent: accent, title: title, body: body),
      ),
    );
  }
}
