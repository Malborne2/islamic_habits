import 'package:flutter/material.dart';

final appThemeData = {
  'PurpleLight': ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.purple,
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light(
      primary: Colors.purple,
      error: Colors.red,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.white),
  ),
  'DarkNormal': ThemeData.dark(),
  'PurpleDark': ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    cardColor: const Color(0xFF0A0A0A),
    highlightColor: Color(0xFFBB86FC).withAlpha(30),
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC),
      onPrimary: Colors.black,
      secondary: Color(0xFFBB86FC),
      onSecondary: Colors.black,
      surface: Color(0xFF0A0A0A),
      onSurface: Colors.white,
      error: Colors.pinkAccent,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: Color(0xFF0A0A0A)),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF0A0A0A)),
    tabBarTheme: const TabBarThemeData(indicatorColor: Color(0xFFBB86FC)),
  ),
};
