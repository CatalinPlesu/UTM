import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ParametersDisplayMode { list, grid_1, grid_2, grid_3 }

class SettingsProvider extends ChangeNotifier {
  late bool _checkAppUpdate = false;
  late bool _checkFirmwareUpdate = false;
  late bool _systemThemeB = true;
  late bool _darkThemeB = false;
  ParametersDisplayMode _displayMode = ParametersDisplayMode.grid_2;

  static ThemeData _lightTheme= ThemeData.light();
  static ThemeData _darkTheme = ThemeData.dark();
  static ThemeMode _themeMode = ThemeMode.system;

  static const String _checkAppUpdateKey = 'checkAppUpdate';
  static const String _checkFirmwareUpdateKey = 'checkFirmwareUpdate';
  static const String _systemThemeKey = 'systemTheme';
  static const String _darkThemeKey = 'darkTheme';
  static const String _displayModeKey = 'displayMode';
  ThemeData get getLightTheme => _lightTheme;
  ThemeData get getDarkTheme => _darkTheme;
  ThemeMode get getThemeMode => _themeMode;

  void loadTheme() async {
    if (systemThemeB) {
      _themeMode = ThemeMode.system;
    } else {
      if (darkThemeB) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    }
    notifyListeners();
  }

  // Load settings from local storage (SharedPreferences)
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load settings if they exist, otherwise, keep the default values
    _checkAppUpdate = prefs.getBool(_checkAppUpdateKey) ?? false;
    _checkFirmwareUpdate = prefs.getBool(_checkFirmwareUpdateKey) ?? false;
    _systemThemeB = prefs.getBool(_systemThemeKey) ?? true;
    _darkThemeB = prefs.getBool(_darkThemeKey) ?? false;
    _displayMode = ParametersDisplayMode.values[
        prefs.getInt(_displayModeKey) ?? ParametersDisplayMode.grid_2.index];

    // Notify listeners after loading settings
    notifyListeners();

    loadTheme();
  }

  bool get checkAppUpdate => _checkAppUpdate;
  set checkAppUpdate(bool newValue) {
    if (_checkAppUpdate != newValue) {
      _checkAppUpdate = newValue;
      _saveToSharedPreferences(_checkAppUpdateKey, newValue);
      notifyListeners();
    }
  }

  bool get checkFirmwareUpdate => _checkFirmwareUpdate;
  set checkFirmwareUpdate(bool newValue) {
    if (_checkFirmwareUpdate != newValue) {
      _checkFirmwareUpdate = newValue;
      _saveToSharedPreferences(_checkFirmwareUpdateKey, newValue);
      notifyListeners();
    }
  }

  bool get systemThemeB => _systemThemeB;
  set systemThemeB(bool newValue) {
    if (_systemThemeB != newValue) {
      _systemThemeB = newValue;
      _saveToSharedPreferences(_systemThemeKey, newValue);
      notifyListeners();
    }
    loadTheme();
  }

  bool get darkThemeB => _darkThemeB;
  set darkThemeB(bool newValue) {
    if (_darkThemeB != newValue) {
      _darkThemeB = newValue;
      _saveToSharedPreferences(_darkThemeKey, newValue);
      notifyListeners();
    }
    loadTheme();
  }

  ParametersDisplayMode get displayMode => _displayMode;
  set displayMode(ParametersDisplayMode newValue) {
    if (_displayMode != newValue) {
      _displayMode = newValue;
      _saveToSharedPreferences(_displayModeKey, newValue.index);
      notifyListeners();
    }
  }

  Future<void> _saveToSharedPreferences(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
  }
}
