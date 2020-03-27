import 'package:flutter/material.dart';
import 'package:islamic_habits/components/habit_drawer.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/prayer_helper.dart';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:hijri/umm_alqura_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/utility/habit.dart';

class PrayersScreen extends StatefulWidget {
  final List<Habit> habits;
  PrayersScreen({@required this.habits});
  @override
  _PrayersScreenState createState() => _PrayersScreenState();
}

class _PrayersScreenState extends State<PrayersScreen> {
  final prayerHelper = PrayerHelper(
      latitude: 25.3157001,
      longitude: 51.8788493,
      calculationMethod: CalculationMethod.QATAR,
      dateTime: DateTime.now());
  final ummAlquraCalendar _today = new ummAlquraCalendar.now();

  Widget createPrayersTable() {
    List<Widget> prayersTimes = prayerHelper.getAllPrayersTime();
    List<Widget> notificationIcons = List.generate(
      5,
      (index) => IconButton(
        icon: Icon(Icons.notifications_active),
        onPressed: () {},
        color: Theme.of(context).textTheme.body1.color,
      ),
    );
    List<Widget> prayersNames = List.generate(
      5,
      (index) => Text(
        kPrayersNames[index],
        style: TextStyle(fontSize: 16),
      ),
    );

    List<Widget> prayersGrid = [];
    for (int i = 0; i < 5; i++) {
      prayersGrid.add(prayersNames[i]);
      prayersGrid.add(notificationIcons[i]);
      prayersGrid.add(prayersTimes[i]);
    }

    List<TableRow> prayerRows = List.generate(
        5,
        (i) => TableRow(children: [
              (prayersNames[i]),
              (notificationIcons[i]),
              (prayersTimes[i]),
            ]));
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 0.5)),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: List.generate(prayerRows.length, (i) => prayerRows[i]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer times'),
      ),
      drawer: HabitDrawer(
        habits: widget.habits,
      ),
      body: Column(
        children: <Widget>[
          Material(
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),
              title: ListTile(
                title: Center(child: Text(_today.toFormat("MMMM dd yyyy"))),
                subtitle: Center(
                    child: Text(
                        DateFormat('EEE, MMM d yyyy').format(DateTime.now()))),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
//          Divider(),
          createPrayersTable(),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(
//                      'Al-Fajir',
//                      style: TextStyle(fontSize: 18),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(
//                      'Al-Dhuhr',
//                      style: TextStyle(fontSize: 18),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(
//                      'Al-Asr',
//                      style: TextStyle(fontSize: 18),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(
//                      'Al-Magrib',
//                      style: TextStyle(fontSize: 18),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text(
//                      'Al-Isha',
//                      style: TextStyle(fontSize: 18),
//                    ),
//                  ),
//                ],
//              ),
//              Column(
//                children: [
//                  IconButton(
//                    icon: Icon(Icons.notifications_active),
//                    onPressed: () {},
//                    color: Colors.black,
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.notifications_active),
//                    onPressed: () {},
//                    color: Colors.black,
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.notifications_active),
//                    onPressed: () {},
//                    color: Colors.black,
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.notifications_active),
//                    onPressed: () {},
//                    color: Colors.black,
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.notifications_active),
//                    onPressed: () {},
//                    color: Colors.black,
//                  ),
//                ],
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.end,
//                children: <Widget>[
//                  PrayerTime(
//                    prayerTime: prayerHelper.getFajr(),
//                  ),
//                  PrayerTime(
//                    prayerTime: prayerHelper.getDhuhr(),
//                  ),
//                  PrayerTime(
//                    prayerTime: prayerHelper.getAsr(),
//                  ),
//                  PrayerTime(
//                    prayerTime: prayerHelper.getMaghrib(),
//                  ),
//                  PrayerTime(
//                    prayerTime: prayerHelper.getIsha(),
//                  ),
//                ],
//              )
//            ],
//          ),
        ],
      ),
    );
  }
}
