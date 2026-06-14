import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: Colors.blue,
      primaryContainer: Colors.indigo,
      secondary: Colors.purple,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo[700],
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontFamily: 'Chewy', fontSize: 19),
    ),
    scrollbarTheme: ScrollbarThemeData(
      interactive: true,
      thickness: WidgetStateProperty.all(8.0),
      radius: const Radius.circular(10.0),
      thumbColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.5)),
      crossAxisMargin: 4.0,
      mainAxisMargin: 4.0,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ).copyWith(primary: Colors.blue[400], secondary: Colors.purple[300]),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo[900],
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontFamily: 'Chewy', fontSize: 19),
    ),
    scrollbarTheme: ScrollbarThemeData(
      interactive: true,
      thickness: WidgetStateProperty.all(8.0),
      radius: const Radius.circular(10.0),
      thumbColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.5)),
      crossAxisMargin: 4.0,
      mainAxisMargin: 4.0,
    ),
  );
}
