import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_habits/utility/numeral_settings.dart';

class PrayerTime extends StatelessWidget {
  final DateTime prayerTime;

  const PrayerTime({super.key, required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Text(
        localizeDigits(
            context,
            DateFormat.jm(Localizations.localeOf(context).toString())
                .format(prayerTime)),
        textAlign: TextAlign.end,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
