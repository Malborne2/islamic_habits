import 'package:flutter/material.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/utility/habit.dart';

class HabitDrawer extends StatelessWidget {
  final List<Habit> habits;
  HabitDrawer({@required this.habits});

  List<Widget> generateChildren(context) {
    List<Widget> children = [
      DrawerHeader(
        padding: EdgeInsets.all(0),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).iconTheme.color,
            onPressed: Navigator.of(context).pop,
          ),
          title: Text('Islamic Habits'),
        ),
//              margin: EdgeInsets.all(2),
//              padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
      ),
      ListTile(
        title: Text('Prayer times'),
        onTap: () {
          // Update the state of the app.
          if (ModalRoute.of(context)?.settings?.name != '/PrayersScreen') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrayersScreen(
                          habits: habits,
                        ),
                    settings: RouteSettings(name: '/PrayersScreen')));
          } else
            Navigator.of(context).pop();
        },
      ),
    ];
    for (Habit habit in habits) {
      children.add(
        ListTile(
          title: Text(habit.name),
          onTap: () {
            // Update the state of the app.
            if (ModalRoute.of(context)?.settings?.name != '/${habit.name}') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitDetail(
                      habit: habit,
                      habits: habits,
                    ),
                    settings: RouteSettings(name: '/${habit.name}'),
                  ));
            } else
              Navigator.of(context).pop();
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
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: generateChildren(context),
      ),
    );
  }
}
