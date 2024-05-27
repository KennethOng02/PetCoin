import 'package:flutter/material.dart';
import 'package:petcoin/screens/signIn.dart';
import 'package:settings_ui/settings_ui.dart';

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    String selectedCurrency = 'NTD';
    bool areNotificationsEnabled = true;

    return Scaffold(
      appBar: AppBar(
        title: Text('S E T T I N G'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: Icon(Icons.account_circle_sharp),
                title: Text('Account'),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
              ),
              SettingsTile(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile(
                title: Text('Currency'),
                leading: Icon(Icons.currency_yen_sharp),
                value: Text(selectedCurrency),
              ),
              SettingsTile.switchTile(
                title: Text('Notifications'),
                leading: Icon(Icons.notifications_active),
                onToggle: (bool isEnabled) {
                  setState(() {
                    areNotificationsEnabled = isEnabled;
                  });
                },
                initialValue: areNotificationsEnabled,
              ),
              SettingsTile(
                title: Text('Log Out'),
                leading: Icon(Icons.logout),
              )
            ],
          ),
        ],
      ),
    );
  }
}
