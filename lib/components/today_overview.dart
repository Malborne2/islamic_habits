import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/components/habit_input_dialog.dart';
import 'package:islamic_habits/components/semiCircle.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';

// Home-screen summary: today's completion ring, the longest active
// streak across all habits, and a quick-tap checklist for today.
class TodayOverview extends StatefulWidget {
  final List<Habit> habits;
  const TodayOverview({super.key, required this.habits});
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
    final completed = todayHabits
        .where((h) => h.getStatus(today) == Status.SUCCESS)
        .length;
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

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
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
                      fillColor: Theme.of(context).colorScheme.primary,
                      lineColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.25),
                      completePercent: percent,
                      width: 8,
                    ),
                    child: Center(
                      child: Text('${percent.round()}%',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          l10n.todayProgress(completed, total),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      if (topHabit != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.longestStreak(
                              l10n.streakDays(topStreak),
                              localizedHabitName(context, topHabit.name)),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (todayHabits.isNotEmpty) ...[
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
                        leading: CircleAvatar(
                          backgroundColor: habit.color,
                          radius: 6,
                        ),
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
                          onPressed: () => _toggleHabit(habit),
                        ),
                        onTap: () => _toggleHabit(habit),
                      ))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}
