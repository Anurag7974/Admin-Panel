import 'package:flutter/material.dart';

import '../services/dark_them_preference.dart';


class DarkThemeProvider with ChangeNotifier {
  // final theme = Utils(context).getTheme;
  // final themeState = Provider.of<DarkThemeProvider>(context);
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}