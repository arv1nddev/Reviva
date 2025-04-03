import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void
main() {
  runApp(
    RevivaApp(),
  );
}

class RevivaApp
    extends
        StatefulWidget {
  const RevivaApp({
    super.key,
  });
  @override
  RevivaAppState createState() =>
      RevivaAppState();
}

class RevivaAppState
    extends
        State<
          RevivaApp
        > {
  bool _isDarkMode =
      false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<
    void
  >
  _loadTheme() async {
    final prefs =
        await SharedPreferences.getInstance();
    setState(
      () {
        _isDarkMode =
            prefs.getBool(
              'darkMode',
            ) ??
            false;
      },
    );
  }

  Future<
    void
  >
  _saveTheme(
    bool value,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setBool(
      'darkMode',
      value,
    );
  }

  void _toggleTheme(
    bool value,
  ) {
    setState(
      () {
        _isDarkMode =
            value;
      },
    );
    _saveTheme(
      value,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      title:
          'Reviva - Transplant Care',
      theme:
          _isDarkMode
              ? ThemeData.dark().copyWith(
                primaryColor:
                    Colors.black,
                scaffoldBackgroundColor:
                    Colors.black87,
              )
              : ThemeData(
                primarySwatch:
                    Colors.blue,
                visualDensity:
                    VisualDensity.adaptivePlatformDensity,
              ),
      initialRoute:
          '/splash',
      routes: {
        '/splash':
            (
              context,
            ) =>
                SplashScreen(),
        '/auth':
            (
              context,
            ) =>
                AuthScreen(),
        '/home':
            (
              context,
            ) => HomeScreen(
              toggleTheme:
                  _toggleTheme,
              isDarkMode:
                  _isDarkMode,
            ),
        '/settings':
            (
              context,
            ) => SettingsScreen(
              toggleTheme:
                  _toggleTheme,
              isDarkMode:
                  _isDarkMode,
            ),
      },
    );
  }
}
