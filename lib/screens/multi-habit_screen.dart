import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/several_habits_page.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SeveralHabitsScreen extends StatefulWidget {
  final List<Habit> habits;
  const SeveralHabitsScreen({super.key, required this.habits});
  @override
  _SeveralHabitsScreenState createState() => _SeveralHabitsScreenState();
}

class _SeveralHabitsScreenState extends State<SeveralHabitsScreen> {
  late PageController controller;
  DateTime currentDate = weekdayDate(Habit.startOfWeek);
  late DateTime _lowerDate;
  late DateTime _upperDate;

  late List<DateTime> startingDates;
  late HijriCalendar hijriFirstDay;
  late HijriCalendar hijriLastDay;

  Widget _buildPages(DateTime dateTime) {
    return SeveralHabitsPage(
      habits: widget.habits,
      currentDate: dateTime,
      onChanged: () => setState(() {}),
    );
  }

  Future<void> _addHabit() async {
    final newHabit = await Navigator.push<Habit>(
        context,
        MaterialPageRoute(
            builder: (context) => const AddHabitScreen(),
            settings: const RouteSettings(name: '/AddHabitScreen')));
    if (newHabit != null) {
      setState(() => widget.habits.add(newHabit));
    }
  }

  @override
  void initState() {
    hijriFirstDay = HijriCalendar.fromDate(currentDate);
    hijriLastDay =
        HijriCalendar.fromDate(currentDate.add(const Duration(days: 7)));
    controller = PageController(initialPage: 1);
    _lowerDate = currentDate.subtract(const Duration(days: 7));
    _upperDate = currentDate.add(const Duration(days: 7));
    startingDates = [_lowerDate, currentDate, _upperDate];

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final habitsToday =
        widget.habits.where((habit) => habit.isHabitDay(today)).toList();
    final completedToday = habitsToday
        .where((habit) => habit.getStatus(today) == Status.SUCCESS)
        .length;
    final todayPercentage = habitsToday.isEmpty
        ? 0
        : (100 * completedToday / habitsToday.length).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All habits'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                completedToday.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 30),
                child: Text(
                  '$todayPercentage%',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
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
                      DateFormat('MMMM yyyy').format(currentDate) ==
                              DateFormat('MMMM yyyy').format(
                                  currentDate.add(const Duration(days: 6)))
                          ? DateFormat('MMMM yyyy').format(currentDate)
                          : '${DateFormat('MMMM').format(currentDate)} - ${DateFormat('MMMM yyyy').format(currentDate.add(const Duration(days: 6)))}',
                      style: const TextStyle(fontSize: 20),
                    )),
                  ),
                  subtitle: Center(
                    child: AutoSizeText(
                      hijriFirstDay.toFormat("MMMM yyyy") ==
                              hijriLastDay.toFormat("MMMM yyyy")
                          ? hijriFirstDay.toFormat("MMMM yyyy")
                          : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}',
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
          Expanded(
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  if (index == startingDates.length - 1) {
                    _upperDate = _upperDate.add(const Duration(days: 7));
                    startingDates.add(_upperDate);
                  }
                  if (index == 0) {
                    _lowerDate =
                        _lowerDate.subtract(const Duration(days: 7));
                    startingDates.insert(0, _lowerDate);
                    controller.jumpTo(
                        1.5 * MediaQuery.of(context).size.width);
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    currentDate = currentDate.add(const Duration(days: 7));
                  }
                  if (index > controller.page!.floor()) {
                    currentDate = currentDate.add(const Duration(days: 7));
                  } else {
                    currentDate =
                        currentDate.subtract(const Duration(days: 7));
                  }

                  hijriFirstDay = HijriCalendar.fromDate(currentDate);
                  hijriLastDay = HijriCalendar.fromDate(
                      currentDate.add(const Duration(days: 7)));
                });
              },
              controller: controller,
              children: List<Widget>.generate(
                startingDates.length,
                (i) => _buildPages(startingDates[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
