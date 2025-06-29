import 'package:flutter/material.dart';
import 'package:chat_app/theme/dark.dart';
import "package:chat_app/theme/light.dart";

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = light;
  ThemeData get themeData => _themeData;
  bool get isDark => _themeData == dark;

  void setTheme(ThemeData theme) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (isDark) {
      _themeData = light;
    } else {
      _themeData = dark;
    }
    notifyListeners();
  }
}
