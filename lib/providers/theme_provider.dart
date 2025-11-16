import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  String _currentThemeName = 'minimal';
  ThemeData _currentTheme = _minimalTheme;

  String get currentThemeName => _currentThemeName;
  ThemeData get currentTheme => _currentTheme;

  static final ThemeData _minimalTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: Colors.grey,
    ),
  );

  static final ThemeData _neonTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF00F0FF),
    scaffoldBackgroundColor: const Color(0xFF0A0E27),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00F0FF),
      secondary: Color(0xFFFF00E5),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Color(0xFFBB86FC),
    ),
  );

  static final ThemeData _pastelTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFB3C6),
    scaffoldBackgroundColor: const Color(0xFFFFF5F7),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFB3C6),
      secondary: Color(0xFFC7CEEA),
    ),
  );

  static final ThemeData _sunsetTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF6B6B),
    scaffoldBackgroundColor: const Color(0xFFFFF4E6),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF6B6B),
      secondary: Color(0xFFFFD93D),
    ),
  );

  void setTheme(String themeName) {
    _currentThemeName = themeName;
    switch (themeName) {
      case 'neon':
        _currentTheme = _neonTheme;
        break;
      case 'dark':
        _currentTheme = _darkTheme;
        break;
      case 'pastel':
        _currentTheme = _pastelTheme;
        break;
      case 'sunset':
        _currentTheme = _sunsetTheme;
        break;
      default:
        _currentTheme = _minimalTheme;
    }
    notifyListeners();
  }
}
