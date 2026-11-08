import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/components/habit_input_dialog.dart';
import 'package:islamic_habits/components/semiCircle.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';

// Home-screen summary: today's completion ring, the longest active
// streak across all habits, and a quick-tap checklist for today.
//
// On wide screens the caller passes `wide: true` and the prayer card as
// `leading`; the summary then sits under the prayer card in a left column
// while today's habits get their own right column. On phones the three
// pieces stack in the original order.
class TodayOverview extends StatefulWidget {
  final List<Habit> habits;
  final Widget? leading;
  final bool wide;

  const TodayOverview({
    super.key,
    required this.habits,
    this.leading,
    this.wide = false,
  });

  @override
  _TodayOverviewState createState() => _TodayOverviewState();
}

class _TodayOverviewState extends State<TodayOverview> {
  Future<void> _toggleHabit(Habit habit) async {
    final today = DateTime.now();
    if (habit.type == HabitType.YES_NO) {
      final current = habit.getHabitDataValue(today);
      setState(() {
        if (current == 1) {
          habit.setHabitDataValue(today, 0);
        } else if (current == 0) {
          habit.setHabitDataValue(today, null);
        } else {
          habit.setHabitDataValue(today, 1);
        }
      });
    } else {
      final value = await showDialog<double>(
          context: context,
          builder: (context) => HabitInputDialog(
              initialValue: habit.getHabitDataValue(today),
              unit: habit.numberUnit));
      if (value != habit.getHabitDataValue(today)) {
        setState(() => habit.setHabitDataValue(today, value));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayHabits =
        widget.habits.where((h) => h.isHabitDay(today)).toList();
    final completed =
        todayHabits.where((h) => h.getStatus(today) == Status.SUCCESS).length;
    final total = todayHabits.length;
    final percent = total == 0 ? 0.0 : 100 * completed / total;

    Habit? topHabit;
    int topStreak = 0;
    for (final h in widget.habits) {
      final streak = h.getCurrentStreak();
      if (streak > topStreak) {
        topStreak = streak;
        topHabit = h;
      }
    }

    final summary = _SummaryCard(
      completed: completed,
      total: total,
      percent: percent,
      topHabit: topHabit,
      topStreak: topStreak,
    );
    final habits = todayHabits.isEmpty
        ? const SizedBox.shrink()
        : _TodayHabitsCard(
            today: today,
            todayHabits: todayHabits,
            onToggle: _toggleHabit,
          );

    if (widget.wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.leading != null) widget.leading!,
                summary,
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 7, child: habits),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.leading != null) widget.leading!,
        summary,
        habits,
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int completed;
  final int total;
  final double percent;
  final Habit? topHabit;
  final int topStreak;

  const _SummaryCard({
    required this.completed,
    required this.total,
    required this.percent,
    required this.topHabit,
    required this.topStreak,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: SemiCircle(
                  fillColor: brandAccent(context),
                  lineColor: brandAccent(context).withValues(alpha: 0.25),
                  completePercent: percent,
                  width: 8,
                ),
                child: Center(
                  // Keep a card-coloured disc behind the number so the
                  // label sits on the card colour, not on the filled pie.
                  // This makes it readable at 0% (empty ring) as well as
                  // at 100% (fully filled ring) in both themes.
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text('${percent.round()}%',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.todayProgress(completed, total),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  if (topHabit != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.longestStreak(l10n.streakDays(topStreak),
                          localizedHabitName(context, topHabit!.name)),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayHabitsCard extends StatelessWidget {
  final DateTime today;
  final List<Habit> todayHabits;
  final Future<void> Function(Habit) onToggle;

  const _TodayHabitsCard({
    required this.today,
    required this.todayHabits,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(l10n.todayHabits,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: todayHabits
                .map((habit) => ListTile(
                      leading: HabitIconBadge(habit: habit),
                      title: Text(localizedHabitName(context, habit.name)),
                      subtitle: habit.type == HabitType.NUMBER
                          ? Text(
                              '${habit.getHabitDataValue(today)?.toStringAsFixed(1) ?? '-'} / ${habit.successValue.toStringAsFixed(0)} ${localizedUnit(context, habit.numberUnit)}')
                          : null,
                      trailing: IconButton(
                        icon: Icon(
                          habit.getStatus(today) == Status.SUCCESS
                              ? Icons.check_circle
                              : habit.getStatus(today) == Status.FAIL
                                  ? Icons.cancel
                                  : Icons.radio_button_unchecked,
                          color: habit.getStatus(today) == Status.SUCCESS
                              ? habit.color
                              : null,
                        ),
                        onPressed: () => onToggle(habit),
                      ),
                      onTap: () => onToggle(habit),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
