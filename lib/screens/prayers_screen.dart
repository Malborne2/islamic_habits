import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';
import 'package:islamic_habits/utility/route_observer.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/functions.dart' show addDays;

class PrayersScreen extends StatefulWidget {
  final List<Habit> habits;
  const PrayersScreen({super.key, required this.habits});
  @override
  _PrayersScreenState createState() => _PrayersScreenState();
}

class _PrayersScreenState extends State<PrayersScreen> with RouteAware {
  DateTime _selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when a route pushed on top of this screen (e.g. Settings) is
  // popped back to it, so prayer time corrections made there show up
  // immediately instead of needing an unrelated navigation first.
  @override
  void didPopNext() {
    setState(() {});
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = addDays(_selectedDate, -1);
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = addDays(_selectedDate, 1);
    });
  }

  void _goToToday() {
    if (_isToday) return;
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _cyclePrayerMode(int index) async {
    const order = [
      PrayerNotifyMode.notify,
      PrayerNotifyMode.silent,
      PrayerNotifyMode.adhan,
    ];
    final current = PrayerSettings.prayerModes[index];
    final next = order[(order.indexOf(current) + 1) % order.length];
    setState(() {});
    await PrayerSettings.setPrayerMode(index, next);
    await NotificationService.scheduleTodayReminders();
    if (mounted) setState(() {});
  }

  IconData _iconForMode(PrayerNotifyMode mode) {
    switch (mode) {
      case PrayerNotifyMode.notify:
        return Icons.notifications_active;
      case PrayerNotifyMode.silent:
        return Icons.notifications_off;
      case PrayerNotifyMode.adhan:
        return Icons.volume_up;
    }
  }

  String _labelForMode(BuildContext context, PrayerNotifyMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case PrayerNotifyMode.notify:
        return l10n.notifyMode;
      case PrayerNotifyMode.silent:
        return l10n.silentMode;
      case PrayerNotifyMode.adhan:
        return l10n.adhanMode;
    }
  }

  Widget createPrayersTable(PrayerHelper prayerHelper) {
    final l10n = AppLocalizations.of(context);
    final localizedPrayerNames = [
      l10n.prayerFajr,
      l10n.prayerDhuhr,
      l10n.prayerAsr,
      l10n.prayerMaghrib,
      l10n.prayerIsha,
    ];
    List<Widget> prayersTimes = prayerHelper.getAllPrayersTime();
    List<Widget> notificationIcons = List.generate(
      5,
      (index) => IconButton(
        icon: Icon(_iconForMode(PrayerSettings.prayerModes[index])),
        tooltip: _labelForMode(context, PrayerSettings.prayerModes[index]),
        onPressed: () => _cyclePrayerMode(index),
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
    List<Widget> prayersNames = List.generate(
      5,
      (index) => Text(
        localizedPrayerNames[index],
        style: const TextStyle(fontSize: 16),
      ),
    );

    List<TableRow> prayerRows = List.generate(
        5,
        (i) => TableRow(children: [
              prayersNames[i],
              notificationIcons[i],
              prayersTimes[i],
            ]));
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Table(
          border: const TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 0.5)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: prayerRows,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    HijriCalendar.setLocal(locale == 'ar' ? 'ar' : 'en');
    final prayerHelper = PrayerHelper.fromSettings(dateTime: _selectedDate);
    final hijriDate = HijriCalendar.fromDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPrayerTimes),
      ),
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: Column(
        children: <Widget>[
          Material(
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _goToPreviousDay,
              ),
              title: InkWell(
                onTap: _goToToday,
                child: ListTile(
                  title: Center(
                      child: Text(localizeDigits(context,
                          hijriDate.toFormat("MMMM dd yyyy")))),
                  subtitle: Center(
                    child: Text(
                      localizeDigits(
                          context,
                          _isToday
                              ? '${l10n.todayLabel} ${DateFormat('MMM d yyyy', locale).format(_selectedDate)}'
                              : DateFormat('EEE, MMM d yyyy', locale)
                                  .format(_selectedDate)),
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _goToNextDay,
              ),
            ),
          ),
          createPrayersTable(prayerHelper),
        ],
      ),
    );
  }
}
