import 'package:flutter/material.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/screens/multi-habit_screen.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/screens/settings_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
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
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => SeveralHabitsScreen(habits: habits),
              settings: const RouteSettings(name: '/SeveralHabitsScreen')),
          (route) => route.settings.name == '/MainScreen');
    }
  }

  // Every drawer destination replaces whatever is currently on top of
  // Home, so Home is always exactly one back-press (or one drawer tap on
  // "Home") away, no matter how deep the user has navigated.
  void _navigateTo(
      BuildContext context, String routeName, WidgetBuilder builder) {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (ModalRoute.of(context)?.settings.name == routeName) return;
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: builder, settings: RouteSettings(name: routeName)),
        (route) => route.settings.name == '/MainScreen');
  }

  void _goHome(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.popUntil((route) => route.settings.name == '/MainScreen');
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
        leading: const Icon(Icons.home_outlined),
        title: const Text('Home'),
        onTap: () => _goHome(context),
      ),
      ListTile(
        title: const Text('Prayer times'),
        onTap: () => _navigateTo(context, '/PrayersScreen',
            (context) => PrayersScreen(habits: habits)),
      ),
      ListTile(
        title: const Text('All habits'),
        onTap: () => _navigateTo(context, '/SeveralHabitsScreen',
            (context) => SeveralHabitsScreen(habits: habits)),
      ),
    ];
    final prayerNames =
        kPrayersNames.map((name) => '$name Prayer').toSet();
    final prayerHabits =
        habits.where((habit) => prayerNames.contains(habit.name)).toList();
    final otherHabits =
        habits.where((habit) => !prayerNames.contains(habit.name)).toList();

    if (prayerHabits.isNotEmpty) {
      children.add(ListTile(
        title: const Text('The five prayers'),
        onTap: () => _navigateTo(
            context,
            '/FivePrayersScreen',
            (context) => SeveralHabitsScreen(
                  habits: prayerHabits,
                  allHabits: habits,
                  title: 'The five prayers',
                  color: Colors.blueGrey,
                  showAddButton: false,
                )),
      ));
    }

    for (Habit habit in otherHabits) {
      children.add(
        ListTile(
          title: Text(habit.name),
          onTap: () => _navigateTo(context, '/${habit.name}',
              (context) => HabitDetail(habit: habit, habits: habits)),
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
