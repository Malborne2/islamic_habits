import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_button.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/components/several_habits_page.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/functions.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/route_observer.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Which localized string to show as the AppBar title. Resolved live from
// AppLocalizations in build() rather than baked into a String field at
// navigation time — otherwise, if the app's language changes while this
// screen is still on the navigator stack, the title stays stuck in
// whatever language was active when the screen was first pushed, even
// though the rest of the screen (which reads AppLocalizations.of(context)
// directly in build) updates immediately.
enum SeveralHabitsTitle { allHabits, fivePrayers }

class SeveralHabitsScreen extends StatefulWidget {
  final List<Habit> habits;
  final List<Habit>? allHabits;
  final SeveralHabitsTitle titleKind;
  final Color color;
  final bool showAddButton;
  const SeveralHabitsScreen({
    super.key,
    required this.habits,
    this.allHabits,
    this.titleKind = SeveralHabitsTitle.allHabits,
    this.color = Colors.teal,
    this.showAddButton = true,
  });
  @override
  _SeveralHabitsScreenState createState() => _SeveralHabitsScreenState();
}

class _SeveralHabitsScreenState extends State<SeveralHabitsScreen>
    with RouteAware {
  late PageController controller;

  // Each page is tracked as a week offset from "this week" (0), rather than
  // an absolute DateTime computed once — Habit.startOfWeek can change later
  // (in Settings) while this screen stays on the navigator stack, and
  // re-deriving the date from the offset + the *current* startOfWeek on
  // every build is what keeps the day-circles' dates aligned with the
  // weekday headers above them (both ultimately read Habit.startOfWeek).
  // Storing an absolute DateTime instead would freeze every page at
  // whatever start-of-week convention was active when it was first built.
  int _currentOffset = 0;
  late int _lowerOffset;
  late int _upperOffset;
  late List<int> _weekOffsets;

  DateTime _dateForOffset(int weekOffset) =>
      addDays(weekdayDate(Habit.startOfWeek), weekOffset * 7);

  DateTime get currentDate => _dateForOffset(_currentOffset);

  late HijriCalendar hijriFirstDay;
  late HijriCalendar hijriLastDay;

  // Local copies so an edit made from this screen's drawer (or a detail page
  // opened from it) is reflected immediately. The habits are reloaded from
  // the database whenever habit data changes, keeping archived/removed ones
  // out of the list as well.
  late List<Habit> _habits;
  List<Habit>? _allHabits;
  int _reloadGeneration = 0;

  Widget _buildPages(int weekOffset) {
    return SeveralHabitsPage(
      habits: _habits,
      allHabits: _allHabits,
      currentDate: _dateForOffset(weekOffset),
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
      setState(() => _habits.add(newHabit));
    }
  }

  void _onHabitDataChanged() {
    _reloadHabits();
  }

  Future<void> _reloadHabits() async {
    final generation = ++_reloadGeneration;
    final active = await HabitDao().getActive();
    if (!mounted || generation != _reloadGeneration) return;
    setState(() {
      // Keep the subset this screen was opened with (all habits or just the
      // five prayers), but use the fresh objects so colors, icons and names
      // update without reopening the screen.
      final visibleIds = _habits.map((habit) => habit.id).toSet();
      _habits = active
          .where((habit) => visibleIds.contains(habit.id))
          .toList();
      _allHabits = widget.allHabits == null ? null : active;
    });
  }

  @override
  void initState() {
    hijriFirstDay = HijriCalendar.fromDate(currentDate);
    hijriLastDay = HijriCalendar.fromDate(addDays(currentDate, 7));
    controller = PageController(initialPage: 1);
    _lowerOffset = _currentOffset - 1;
    _upperOffset = _currentOffset + 1;
    _weekOffsets = [_lowerOffset, _currentOffset, _upperOffset];
    _habits = List<Habit>.of(widget.habits);
    _allHabits = widget.allHabits == null
        ? null
        : List<Habit>.of(widget.allHabits!);
    NotificationService.habitDataRevision.addListener(_onHabitDataChanged);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    NotificationService.habitDataRevision.removeListener(_onHabitDataChanged);
    appRouteObserver.unsubscribe(this);
    controller.dispose();
    super.dispose();
  }

  // Called when a route pushed on top of this screen (e.g. Settings) is
  // popped back to it, so a start-of-week change made there is reflected in
  // the Hijri month range header immediately — the day-circles' own dates
  // are already derived fresh from Habit.startOfWeek on every build via
  // _dateForOffset, so they just need this rebuild to pick it up too.
  @override
  void didPopNext() {
    setState(() {
      hijriFirstDay = HijriCalendar.fromDate(currentDate);
      hijriLastDay = HijriCalendar.fromDate(addDays(currentDate, 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    final today = DateTime.now();
    final habitsToday =
        _habits.where((habit) => habit.isHabitDay(today)).toList();
    final completedToday = habitsToday
        .where((habit) => habit.getStatus(today) == Status.SUCCESS)
        .length;
    final todayPercentage = habitsToday.isEmpty
        ? 0
        : (100 * completedToday / habitsToday.length).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleKind == SeveralHabitsTitle.fivePrayers
            ? AppLocalizations.of(context).navFivePrayers
            : AppLocalizations.of(context).navAllHabits),
        backgroundColor: widget.color,
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
        habits: _allHabits ?? _habits,
      ),
      floatingActionButton: widget.showAddButton
          ? FloatingActionButton(
              onPressed: _addHabit,
              child: const Icon(Icons.add),
            )
          : null,
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
                      localizeDigits(
                          context,
                          DateFormat('MMMM yyyy', locale)
                                      .format(currentDate) ==
                                  DateFormat('MMMM yyyy', locale)
                                      .format(addDays(currentDate, 6))
                              ? DateFormat('MMMM yyyy', locale)
                                  .format(currentDate)
                              : '${DateFormat('MMMM', locale).format(currentDate)} - ${DateFormat('MMMM yyyy', locale).format(addDays(currentDate, 6))}'),
                      style: const TextStyle(fontSize: 20),
                    )),
                  ),
                  subtitle: Center(
                    child: AutoSizeText(
                      localizeDigits(
                          context,
                          hijriFirstDay.toFormat("MMMM yyyy") ==
                                  hijriLastDay.toFormat("MMMM yyyy")
                              ? hijriFirstDay.toFormat("MMMM yyyy")
                              : '${hijriFirstDay.toFormat("MMMM")} - ${hijriLastDay.toFormat("MMMM yyyy")}'),
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
                  if (index == _weekOffsets.length - 1) {
                    _upperOffset += 1;
                    _weekOffsets.add(_upperOffset);
                  }
                  if (index == 0) {
                    _lowerOffset -= 1;
                    _weekOffsets.insert(0, _lowerOffset);
                    controller.jumpTo(
                        1.5 * MediaQuery.of(context).size.width);
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    _currentOffset += 1;
                  }
                  if (index > controller.page!.floor()) {
                    _currentOffset += 1;
                  } else {
                    _currentOffset -= 1;
                  }

                  hijriFirstDay = HijriCalendar.fromDate(currentDate);
                  hijriLastDay =
                      HijriCalendar.fromDate(addDays(currentDate, 7));
                });
              },
              controller: controller,
              children: List<Widget>.generate(
                _weekOffsets.length,
                (i) => _buildPages(_weekOffsets[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
