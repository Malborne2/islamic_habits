import 'package:flutter/material.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/screens/multi-habit_screen.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/screens/settings_screen.dart';
import 'package:islamic_habits/utility/habit.dart';

class HabitDrawer extends StatelessWidget {
  final List<Habit> habits;
  const HabitDrawer({super.key, required this.habits});

  Future<void> _addHabit(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    final newHabit = await navigator.push<Habit>(
        MaterialPageRoute(
            builder: (context) => const AddHabitScreen(),
            settings: const RouteSettings(name: '/AddHabitScreen')));
    if (newHabit != null) {
      habits.add(newHabit);
      navigator.push(
          MaterialPageRoute(
              builder: (context) => SeveralHabitsScreen(habits: habits),
              settings: const RouteSettings(name: '/SeveralHabitsScreen')));
    }
  }

  List<Widget> generateChildren(BuildContext context) {
    List<Widget> children = [
      DrawerHeader(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).iconTheme.color,
                onPressed: Navigator.of(context).pop,
              ),
              title: const Text('Islamic Habits'),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                          settings:
                              const RouteSettings(name: '/SettingsScreen')));
                },
              ),
            ),
            InkWell(
              onTap: () => _addHabit(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_circle_outline,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 12),
                    Text('Add new habit',
                        style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ListTile(
        title: const Text('Prayer times'),
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != '/PrayersScreen') {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrayersScreen(habits: habits),
                    settings: const RouteSettings(name: '/PrayersScreen')));
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      ListTile(
        title: const Text('All habits'),
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != '/SeveralHabitsScreen') {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SeveralHabitsScreen(habits: habits),
                    settings:
                        const RouteSettings(name: '/SeveralHabitsScreen')));
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    ];
    for (Habit habit in habits) {
      children.add(
        ListTile(
          title: Text(habit.name),
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != '/${habit.name}') {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HabitDetail(habit: habit, habits: habits),
                    settings: RouteSettings(name: '/${habit.name}'),
                  ));
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: generateChildren(context),
      ),
    );
  }
}
