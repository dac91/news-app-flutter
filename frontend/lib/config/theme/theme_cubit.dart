import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit for managing the app's theme mode (light/dark/system).
///
/// Persists the user's choice to SharedPreferences so it survives
/// app restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system);

  /// Call once at startup to hydrate from disk.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored != null) {
      emit(_fromString(stored));
    }
  }

  /// Toggle between light, dark, and system.
  Future<void> toggleTheme() async {
    final next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    emit(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, next.name);
  }

  /// Set a specific theme mode.
  Future<void> setTheme(ThemeMode mode) async {
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  ThemeMode _fromString(String value) {
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  /// Returns the icon to display for the current theme mode.
  IconData get icon => switch (state) {
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
        ThemeMode.system => Icons.brightness_auto,
      };
}
