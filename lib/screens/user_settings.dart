import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/model/auth.dart';
import 'package:settings_ui/settings_ui.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  SettingsTile _account() {
    return SettingsTile(
      leading: Icon(Icons.language),
      title: Text('Account'),
      value: Text(user!.email.toString()),
    );
  }

  SettingsTile _language() {
    return SettingsTile(
      leading: Icon(Icons.language),
      title: Text('Language'),
      value: Text('English'),
    );
  }

  SettingsTile _currency(String selectedCurrency) {
    return SettingsTile(
      title: Text('Currency'),
      leading: Icon(Icons.currency_yen_sharp),
      value: Text(selectedCurrency),
    );
  }

  Widget _logout() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

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
              _account(),
              _language(),
              _currency(selectedCurrency),
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
                title: Text('Logout'),
                onPressed: (context) => signOut(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
