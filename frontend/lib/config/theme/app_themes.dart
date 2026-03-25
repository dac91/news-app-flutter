import 'package:flutter/material.dart';

/// Light theme — the original app theme, preserved and formalized.
ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Muli',
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
      onSurfaceVariant: Color(0xFF8B8B8B),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0XFF8B8B8B)),
      titleTextStyle: TextStyle(
        color: Color(0XFF8B8B8B),
        fontSize: 18,
        fontFamily: 'Muli',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}

/// Dark theme — inverted palette for low-light usage.
ThemeData darkTheme() {
  const surfaceColor = Color(0xFF121212);
  const cardColor = Color(0xFF1E1E1E);

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: surfaceColor,
    fontFamily: 'Muli',
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.white70,
      surface: cardColor,
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFFB0B0B0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white70),
      titleTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontFamily: 'Muli',
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.black),
    ),
    cardColor: cardColor,
  );
}

// Keep backward compatibility — theme() returns lightTheme.
ThemeData theme() => lightTheme();
