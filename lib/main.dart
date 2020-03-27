import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/screens/main_screen.dart';
//import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/utility/Themes/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(IslamicHabits());
}

class IslamicHabits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );
  }

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      title: 'Islamic Habits',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: state.themeData,
    );
  }
}
