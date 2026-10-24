import 'dart:ui';

import 'package:islamic_habits/screens/main_screen.dart';
import 'package:islamic_habits/screens/onboarding_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/language_settings.dart';
import 'package:islamic_habits/utility/notification_service.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';
import 'package:islamic_habits/utility/shared_prefrences_helper.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:islamic_habits/utility/habit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<Habit> islamicHabits = [];
  bool loading = true;

  void initializeHabits() async {
    HabitDao dao = HabitDao();
    bool isEmpty = await dao.isEmpty();
    if (isEmpty) {
      islamicHabits = List.generate(
          6,
          (i) => Habit(
              name: i < kPrayersNames.length
                  ? '${kPrayersNames[i]} Prayer'
                  : 'Reciting the Quran',
              color: kHabitColors[i % kHabitColors.length],
              habitData: {},
              successValue: i < kPrayersNames.length ? 1 : 5,
              criteria: Criteria.AT_LEAST,
              type: i < kPrayersNames.length
                  ? HabitType.YES_NO
                  : HabitType.NUMBER));
      for (Habit habit in islamicHabits) {
        await dao.addHabit(habit);
      }
    } else {
      islamicHabits = await dao.getActive();
    }

    await PrayerSettings.load();
    await NotificationService.initialize();

    final savedStartOfWeek = await SharedPreferencesHelper.getStartOfWeek();
    // No explicit choice saved yet (first run, or never touched in
    // Settings) — default to Sunday for Arabic, Monday everywhere else,
    // matching common regional convention. The user can still change it
    // in Settings at any time, which persists and overrides this default.
    final languageCode = LanguageSettings.locale?.languageCode ??
        PlatformDispatcher.instance.locale.languageCode;
    final defaultStartOfWeek =
        languageCode == 'ar' ? DateTime.sunday : DateTime.monday;
    kStartOfWeek = savedStartOfWeek ?? defaultStartOfWeek;
    Habit.startOfWeek = savedStartOfWeek ?? defaultStartOfWeek;

    // First-run tour, before the system permission prompt so a brand-new
    // user understands what the app does before being asked to allow
    // notifications.
    final onboardingCompleted =
        await SharedPreferencesHelper.getOnboardingCompleted();
    if (!onboardingCompleted && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
          settings: const RouteSettings(name: '/OnboardingScreen'),
        ),
      );
      await SharedPreferencesHelper.setOnboardingCompleted(true);
    }

    await NotificationService.requestPermission();
    await NotificationService.scheduleTodayReminders();
    await NotificationService.scheduleHabitReminders();

    if (!mounted) return;
    // Replace the loading route instead of stacking Home on top of it.
    // Otherwise pressing back on Home landed on the blank loading scaffold
    // before the app finally closed.
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            islamicHabits: islamicHabits,
          ),
          settings: const RouteSettings(name: '/MainScreen'),
        ));
    setState(() {
      loading = false;
    });
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
