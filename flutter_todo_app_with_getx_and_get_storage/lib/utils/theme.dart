import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.light,
      primary: Color(0xffFF6E00),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 26),
      titleMedium: TextStyle(fontSize: 23),
      titleSmall: TextStyle(fontSize: 20),
      labelMedium: TextStyle(fontSize: 15),
      labelSmall: TextStyle(fontSize: 12),
    ),
    hintColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
    ),
    useMaterial3: true,
    primaryColor: Colors.white,
    primaryColorDark: const Color(0xff292D36),
    scaffoldBackgroundColor: const Color(0xff22252D),
    iconTheme: const IconThemeData(color: Colors.white, size: 24),
  );
}
