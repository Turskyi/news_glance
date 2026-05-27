import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: Colors.blue,
      primaryContainer: Colors.indigo,
      secondary: Colors.purple,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
      ).primaryContainer,
      // This changes the color of AppBar icons.
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontFamily: 'Chewy', fontSize: 19),
    ),
  );
}
