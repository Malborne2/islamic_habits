import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerTime extends StatelessWidget {
  final Future<DateTime> prayerTime;

  PrayerTime({@required this.prayerTime});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: FutureBuilder(
        future: prayerTime,
        builder: (context, AsyncSnapshot<DateTime> snapshot) {
          if (snapshot.hasData) {
            final dateTime = snapshot.data.toLocal();
            return Text(
              DateFormat.jm().format(dateTime),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 18,
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(
              'error',
              style: TextStyle(color: Theme.of(context).errorColor),
            );
          } else {
            return Text('');
          }
        },
      ),
    );
  }
}
