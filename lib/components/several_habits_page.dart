import 'package:flutter/material.dart';
import 'package:islamic_habits/components/buttonsList.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/responsive.dart';
import 'package:islamic_habits/utility/weekday_localizer.dart';

class SeveralHabitsPage extends StatefulWidget {
  final DateTime currentDate;
  final List<Habit> habits;
  // The full habit list, for the drawer on the detail screen a tap here
  // opens — habits may be a filtered subset (e.g. just the five prayers),
  // in which case that drawer would otherwise only show this subset too.
  final List<Habit>? allHabits;
  final VoidCallback? onChanged;

  // "Reorder habits" mode: instead of the weekly grids, show one card per
  // habit that can be dragged (or moved with the arrow buttons). The screen
  // owns the order and persists it, so every week page shows the same list.
  final bool reordering;
  final void Function(int from, int to)? onMoveHabit;

  const SeveralHabitsPage(
      {super.key,
      required this.currentDate,
      required this.habits,
      this.allHabits,
      this.onChanged,
      this.reordering = false,
      this.onMoveHabit});
  @override
  _SeveralHabitsPageState createState() => _SeveralHabitsPageState();
}

class _SeveralHabitsPageState extends State<SeveralHabitsPage> {
  List<Widget> generateHabitsList(double itemWidth) {
    List<Widget> habitWidgets = [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: List.generate(
            7,
            (i) => SizedBox(
                width: itemWidth,
                child: Center(
                    child: Text(localizedWeekdayShort(
                        context, weekdayForColumn(kStartOfWeek, i))))),
          ),
        ),
      )
    ];

    for (Habit habit in widget.habits) {
      habitWidgets
        ..add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetail(
                      habit: habit, habits: widget.allHabits ?? widget.habits),
                  settings: RouteSettings(name: '/${habit.name}'),
                ));
          },
          child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                localizedHabitName(context, habit.name),
                style: TextStyle(color: habit.color),
              )),
        ))
        ..add(ButtonsList(
          length: 7,
          isHabitDetail: false,
          startOfWeek: Habit.startOfWeek,
          habit: habit,
          failColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.brown.shade800
              : Colors.brown.shade300,
          startDate: widget.currentDate,
          onChanged: widget.onChanged,
        ));
    }

    return habitWidgets;
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    if (oldIndex == newIndex) return;
    widget.onMoveHabit?.call(oldIndex, newIndex);
  }

  Widget _buildReorderList(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accent = brandAccent(context);
    return ContentWidth(
      maxWidth: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.touch_app_outlined, size: 20, color: accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.reorderHabitsHint,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
              itemCount: widget.habits.length,
              onReorder: _onReorder,
              proxyDecorator: (child, index, animation) => AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final lift = Curves.easeInOut.transform(animation.value);
                  return Transform.scale(
                    scale: 1 + 0.02 * lift,
                    child: Material(
                      elevation: 6 * lift,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: child,
                    ),
                  );
                },
              ),
              itemBuilder: (context, index) {
                final habit = widget.habits[index];
                return _ReorderHabitCard(
                  key: ValueKey<int?>(habit.id),
                  habit: habit,
                  index: index,
                  onMoveUp: index == 0
                      ? null
                      : () => widget.onMoveHabit?.call(index, index - 1),
                  onMoveDown: index == widget.habits.length - 1
                      ? null
                      : () => widget.onMoveHabit?.call(index, index + 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reordering) return _buildReorderList(context);

    return ContentWidth(
      maxWidth: 640,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = constraints.maxWidth / 7;
          return SingleChildScrollView(
            child: Column(
              children: generateHabitsList(itemWidth),
            ),
          );
        },
      ),
    );
  }
}

// One row in "Reorder habits" mode. Drag it by the handle at the end of the
// row, or use the arrow buttons for a precise move; the arrows also work with
// screen readers.
class _ReorderHabitCard extends StatelessWidget {
  final Habit habit;
  final int index;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const _ReorderHabitCard({
    super.key,
    required this.habit,
    required this.index,
    required this.onMoveUp,
    required this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = brandAccent(context);
    final isDark = theme.brightness == Brightness.dark;
    final moved = onMoveUp != null || onMoveDown != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: moved
                ? habit.color.withValues(alpha: 0.55)
                : theme.dividerColor.withValues(alpha: 0.4),
            width: moved ? 1.4 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: <Widget>[
              // Position badge: makes the new order obvious after a move.
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              HabitIconBadge(habit: habit, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  localizedHabitName(context, habit.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: l10n.moveHabitUp,
                icon: Icon(
                  Icons.keyboard_arrow_up,
                  color: onMoveUp == null ? theme.disabledColor : null,
                ),
                onPressed: onMoveUp,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                tooltip: l10n.moveHabitDown,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: onMoveDown == null ? theme.disabledColor : null,
                ),
                onPressed: onMoveDown,
                visualDensity: VisualDensity.compact,
              ),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.drag_handle,
                    color: accent.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
