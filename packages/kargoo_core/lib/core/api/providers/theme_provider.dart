import 'package:flutter/material.dart';
import '../../preferences/preference_keys.dart';
import '../../preferences/preferences_util.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferenceManager _cache = PreferenceManager.instance;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    saveTheme();
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final isDark = _cache.getBoolValue(PreferenceKeys.isDark);
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> saveTheme() async {
    await _cache.setBoolValue(
      PreferenceKeys.isDark,
      _themeMode == ThemeMode.dark,
    );
  }
}
