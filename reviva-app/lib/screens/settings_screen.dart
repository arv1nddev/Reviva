// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'about.dart';
import 'account_security_screeen.dart';
import 'medical_access_screens.dart';

class SettingsScreen
    extends
        StatefulWidget {
  final Function(
    bool,
  )
  toggleTheme;
  final bool isDarkMode;

  const SettingsScreen({
    required this.toggleTheme,
    required this.isDarkMode,
    super.key,
  });

  @override
  SettingsScreenState createState() =>
      SettingsScreenState();
}

class SettingsScreenState
    extends
        State<
          SettingsScreen
        > {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(
              'Dark Mode',
            ),
            subtitle: Text(
              widget.isDarkMode
                  ? 'Enabled'
                  : 'Disabled',
            ),
            secondary: Icon(
              widget.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            value:
                widget.isDarkMode,
            onChanged: (
              value,
            ) {
              widget.toggleTheme(
                value,
              );
              setState(
                () {},
              );
            },
          ),
          // ListTile(
          //   title: Text(
          //     'Notification Settings',
          //   ),
          //   trailing: Icon(
          //     Icons.notifications,
          //   ),
          //   onTap:
          //       () {},
          // ),

          // AccountSecurityScreen


          ListTile(
            title: Text(
              'Account Security',
            ),
            trailing: Icon(
              Icons.security,
            ),
            onTap:
                () { Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (
                        context,
                      ) =>
                          const AccountSecurityScreen(),
                ),
              );},
          ),

          //  MedicalAccessScreen

          ListTile(
            title: Text(
              'Medical Team Access',
            ),
            trailing: Icon(
              Icons.people,
            ),
            onTap:
                () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (
                        context,
                      ) =>
                          const MedicalAccessScreen(),
                ),
              );},
          ),
          ListTile(
            title: Text(
              'About Reviva',
            ),
            trailing: Icon(
              Icons.info,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (
                        context,
                      ) =>
                          const AboutScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Logout',
            ),
            trailing: Icon(
              Icons.logout,
            ),
            onTap:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/auth',
                ),
          ),
        ],
      ),
    );
  }
}
