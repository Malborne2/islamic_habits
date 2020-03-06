import 'dart:async';
import 'package:adhan_flutter/adhan_flutter.dart';
import 'package:flutter/cupertino.dart';

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
    return await adhan.timeForPrayer(await adhan.nextPrayer());
  }

  Future<String> getNextPrayerName() async {
    return adhan.nextPrayer().then((prayer) =>
        prayer.toString().substring(7)[0] +
        prayer.toString().substring(8).toLowerCase());
  }

  Future<DateTime> getFajr() async {
    return await adhan.fajr;
  }

  Future<DateTime> getDhuhr() async {
    return await adhan.dhuhr;
  }

  Future<DateTime> getAsr() async {
    return await adhan.asr;
  }

  Future<DateTime> getMaghrib() async {
    return await adhan.maghrib;
  }

  Future<DateTime> getIsha() async {
    return await adhan.isha;
  }
}
