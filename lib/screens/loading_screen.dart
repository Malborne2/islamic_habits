import 'package:islamic_habits/screens/main_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:islamic_habits/utility/habit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<Habit> islamicHabits;
  bool loading = true;

  void initializeHabits() async {
    HabitDao dao = HabitDao();
    bool isEmpty = await dao.isEmpty();
    if (isEmpty) {
      print('isEmpty is true');
      islamicHabits = List.generate(
          6,
          (i) => Habit(
              name: i < kPrayersNames.length
                  ? '${kPrayersNames[i]} Prayer'
                  : 'Reciting the Quran',
              color: kHabitColors[i % kHabitColors.length],
              habitData: {},
              successValue: i < kPrayersNames.length ? 1 : 20,
              criteria: Criteria.AT_LEAST,
              type: i < kPrayersNames.length
                  ? HabitType.YES_NO
                  : HabitType.NUMBER));
      for (Habit habit in islamicHabits) {
        dao.addHabit(habit);
      }
      loading = false;
    } else {
      print('isEmpty is false');
      islamicHabits = await dao.getAll();
      loading = false;
    }
    if (!loading)
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              islamicHabits: islamicHabits,
            ),
          ));
  }

  @override
  void initState() {
    super.initState();
    initializeHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(),
      ),
    );
  }
}
