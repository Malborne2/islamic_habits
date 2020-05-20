import 'screens/loading_screen.dart';
import 'package:islamic_habits/utility/bloc/bloc.dart';
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
      home: LoadingScreen(),
      theme: state.themeData,
    );
  }
}
