import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode applight = ThemeMode.light;
  bool _isDarkMode = false;
  String local = 'en_US';
  Locale _locale = const Locale('en', '');

  ThemeNotifier() {
    _loadTheme();
    _loadLocale();
  }

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;

  String toggleLocal() {
    if (_locale == Locale('en', '')) {
      return 'en_US';
    } else {
      return 'ar_EGYPT';
    }
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    applight = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  void changeTheme(ThemeMode themeMode) {
    applight = themeMode;
    _isDarkMode = (themeMode == ThemeMode.dark);
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    applight = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void changeLanguage(Locale newLocale) {
    _locale = newLocale;
    _saveLocale();
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale_language') ?? 'en';
    final countryCode = prefs.getString('locale_country') ?? '';
    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_language', _locale.languageCode);
    await prefs.setString('locale_country', _locale.countryCode ?? '');
  }
}
