import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ThemeNotifier with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleTheme() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }
}
