import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:islamic_habits/components/prayer_time.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

class PrayerHelper {
  final double latitude;
  final double longitude;
  final CalculationParameters parameters;
  final DateTime dateTime;
  final PrayerTimes adhan;

  PrayerHelper({
    required this.latitude,
    required this.longitude,
    required this.parameters,
    required this.dateTime,
  }) : adhan = PrayerTimes(
          Coordinates(latitude, longitude),
          DateComponents.from(dateTime),
          parameters,
        );

  factory PrayerHelper.fromSettings({DateTime? dateTime}) {
    return PrayerHelper(
      latitude: PrayerSettings.latitude,
      longitude: PrayerSettings.longitude,
      parameters: PrayerSettings.getParameters(),
      dateTime: dateTime ?? DateTime.now(),
    );
  }

  Prayer currentPrayer() {
    return adhan.currentPrayer();
  }

  DateTime getNextPrayerTime() {
    final nextPrayer = adhan.nextPrayer();
    if (nextPrayer != Prayer.none) {
      return adhan.timeForPrayer(nextPrayer)!;
    }
    return PrayerTimes(
      Coordinates(latitude, longitude),
      DateComponents.from(DateTime.now().add(const Duration(days: 1))),
      parameters,
    ).fajr;
  }

  DateTime getLaterPrayerTime() {
    final laterPrayerName = getLaterPrayerName();
    switch (laterPrayerName) {
      case 'Fajr':
        return PrayerTimes(
          Coordinates(latitude, longitude),
          DateComponents.from(DateTime.now().add(const Duration(days: 1))),
          parameters,
        ).fajr;
      case 'Dhuhr':
        return getDhuhr();
      case 'Asr':
        return getAsr();
      case 'Maghrib':
        return getMaghrib();
      case 'Isha':
        return getIsha();
      case 'Sunrise':
        return getSunrise();
      default:
        return getFajr();
    }
  }

  String getNextPrayerName() {
    final nextPrayer = adhan.nextPrayer();
    if (nextPrayer == Prayer.none) return 'Fajr';
    return _prayerDisplayName(nextPrayer);
  }

  String getLaterPrayerName() {
    final nextPrayer = adhan.nextPrayer();
    final name = nextPrayer == Prayer.none ? 'None' : _prayerDisplayName(nextPrayer);
    switch (name) {
      case 'Fajr':
        return 'Sunrise';
      case 'Sunrise':
        return 'Dhuhr';
      case 'Dhuhr':
        return 'Asr';
      case 'Asr':
        return 'Maghrib';
      case 'Maghrib':
        return 'Isha';
      case 'Isha':
      case 'None':
        return 'Fajr';
      default:
        return 'Fajr';
    }
  }

  String _prayerDisplayName(Prayer prayer) {
    final n = prayer.name;
    return n[0].toUpperCase() + n.substring(1).toLowerCase();
  }

  DateTime getFajr() => adhan.fajr;
  DateTime getSunrise() => adhan.sunrise;
  DateTime getDhuhr() => adhan.dhuhr;
  DateTime getAsr() => adhan.asr;
  DateTime getMaghrib() => adhan.maghrib;
  DateTime getIsha() => adhan.isha;

  List<Widget> getAllPrayersTime() {
    return [
      adhan.fajr,
      adhan.dhuhr,
      adhan.asr,
      adhan.maghrib,
      adhan.isha,
    ].map((t) => PrayerTime(prayerTime: t)).toList();
  }
}
