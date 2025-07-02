import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme light = ColorScheme.light();
  static const ColorScheme dark = ColorScheme.dark();
  static const Color appBarColor = Color(0xFF4DAF50);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black)
    ),
    iconTheme: IconThemeData(color: Colors.green),
    appBarTheme: const AppBarTheme(
      color: Colors.green,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.green,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.light(
      primary: appBarColor,
      secondary: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.grey[800],
    iconTheme: const IconThemeData(color: Colors.green),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
  ),
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.green,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 2,
      shadowColor: Colors.grey,
    ),
    colorScheme: ColorScheme.dark(
      primary: appBarColor,
      secondary: Colors.white,
    ),
  );
}
