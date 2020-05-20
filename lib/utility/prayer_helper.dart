import 'dart:async';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:islamic_habits/components/prayer_time.dart';

class PrayerHelper {
  final double latitude;
  final double longitude;
  final CalculationMethod calculationMethod;
  final DateTime dateTime;
  final Adhan adhan;

  PrayerHelper(
      {@required this.latitude,
      @required this.longitude,
      @required this.calculationMethod,
      @required this.dateTime})
      : adhan = AdhanFlutter.create(
            Coordinates(latitude, longitude), dateTime, calculationMethod);

  Future<Prayer> getCurrentPrayer() async {
    return await adhan.currentPrayer();
  }

  Future<DateTime> getNextPrayerTime() async {
    var nextPrayer = await adhan.nextPrayer();
    var nextPrayerTime = nextPrayer != Prayer.NONE
        ? await adhan.timeForPrayer(nextPrayer)
        : await AdhanFlutter.create(
                Coordinates(latitude, longitude),
                dateTime.add(Duration(hours: 24 - dateTime.hour)),
                calculationMethod)
            .fajr;

    return nextPrayerTime;
  }

  Future<DateTime> getLaterPrayerTime() async {
    var laterPrayerName = await getLaterPrayerName();
    switch (laterPrayerName) {
      case 'Fajr':
        return await AdhanFlutter.create(
                Coordinates(latitude, longitude),
                dateTime.add(Duration(hours: 24 - dateTime.hour)),
                calculationMethod)
            .fajr; //get the prayer the next day
      case 'Dhuhr':
        return getDhuhr();
      case 'Asr':
        return getAsr();
      case 'Magrib':
        return getMaghrib();
      case 'Isha':
        return getIsha();
      case 'Sunrise':
        return getSunrise();
      default:
        return getFajr();
    }
  }

  Future<String> getNextPrayerName() async {
    var nextPrayer = await adhan.nextPrayer();
    if (nextPrayer == Prayer.NONE)
      return 'Fajr';
    else
      return adhan.nextPrayer().then((prayer) =>
          prayer.toString().substring(7)[0] +
          prayer.toString().substring(8).toLowerCase());
  }

  Future<String> getLaterPrayerName() async {
    var nextPrayer = await adhan.nextPrayer().then((prayer) =>
        prayer.toString().substring(7)[0] +
        prayer.toString().substring(8).toLowerCase());

    switch (nextPrayer) {
      case 'Fajr':
        return 'Sunrise';
      case 'Sunrise':
        return 'Dhuhr';
      case 'Dhuhr':
        return 'Asr';
      case 'Asr':
        return 'Magrib';
      case 'Maghrib':
        return 'Isha';
      case 'Isha':
        return 'Fajr';
      case 'None':
        return 'Sunrise';
      default:
        return 'Fajr';
    }
  }

  Future<DateTime> getFajr() async {
    return await adhan.timeForPrayer(Prayer.FAJR);
  }

  Future<DateTime> getSunrise() async {
    return await adhan.timeForPrayer(Prayer.SUNRISE);
  }

  Future<DateTime> getDhuhr() async {
    return await adhan.timeForPrayer(Prayer.DHUHR);
  }

  Future<DateTime> getAsr() async {
    return await adhan.timeForPrayer(Prayer.ASR);
  }

  Future<DateTime> getMaghrib() async {
    return await adhan.timeForPrayer(Prayer.MAGHRIB);
  }

  Future<DateTime> getIsha() async {
    return await adhan.timeForPrayer(Prayer.ISHA);
  }

  List<Widget> getAllPrayersTime() {
    List<Widget> prayersTimeWidgets = [];
    List<Future<DateTime>> prayersTimes = [
      adhan.timeForPrayer(Prayer.FAJR),
      adhan.timeForPrayer(Prayer.DHUHR),
      adhan.timeForPrayer(Prayer.ASR),
      adhan.timeForPrayer(Prayer.MAGHRIB),
      adhan.timeForPrayer(Prayer.ISHA),
    ];

    for (Future<DateTime> prayerTime in prayersTimes) {
      prayersTimeWidgets.add(PrayerTime(
        prayerTime: prayerTime,
      ));
    }
    return prayersTimeWidgets;
  }
}
