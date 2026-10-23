import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/notification_service.dart';

// Archived habits keep every logged day but are hidden from Home, the
// drawer's habit list, reminders, and statistics. This screen is the only
// place they show up, and is where they can be restored or deleted.
class ArchivedHabitsScreen extends StatefulWidget {
  const ArchivedHabitsScreen({super.key});

  @override
  State<ArchivedHabitsScreen> createState() => _ArchivedHabitsScreenState();
}

class _ArchivedHabitsScreenState extends State<ArchivedHabitsScreen> {
  List<Habit> _archived = <Habit>[];
  List<Habit> _active = <Habit>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final archived = await HabitDao().getArchived();
    final active = await HabitDao().getActive();
    if (!mounted) return;
    setState(() {
      _archived = archived;
      _active = active;
      _loading = false;
    });
  }

  Future<void> _restore(Habit habit) async {
    final l10n = AppLocalizations.of(context);
    await HabitDao().updateHabit(habit..archived = false);
    await NotificationService.scheduleHabitReminders();
    NotificationService.habitDataRevision.value++;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.habitRestored)),
    );
    await _load();
  }

  Future<void> _delete(Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.deleteHabitTitle),
            content: Text(l10n.deleteHabitMessage(
                localizedHabitName(dialogContext, habit.name))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    await HabitDao().deleteHabit(habit);
    await NotificationService.scheduleHabitReminders();
    NotificationService.habitDataRevision.value++;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.habitDeleted)),
    );
    await _load();
  }

  Future<void> _openDetail(Habit habit) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetail(habit: habit, habits: _active),
        settings: RouteSettings(name: '/ArchivedHabit/${habit.name}'),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.archivedHabits)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _archived.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.archive_outlined,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noArchivedHabits,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        l10n.archivedHabitsHint,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    for (final habit in _archived)
                      ListTile(
                        leading: HabitIconBadge(habit: habit),
                        title:
                            Text(localizedHabitName(context, habit.name)),
                        onTap: () => _openDetail(habit),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'restore') {
                              _restore(habit);
                            } else if (value == 'delete') {
                              _delete(habit);
                            }
                          },
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'restore',
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.unarchive_outlined),
                                title: Text(l10n.unarchive),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.delete_outline,
                                    color: theme.colorScheme.error),
                                title: Text(
                                  l10n.delete,
                                  style: TextStyle(
                                      color: theme.colorScheme.error),
                                ),
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
