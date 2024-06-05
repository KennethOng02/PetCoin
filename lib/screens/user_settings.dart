import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/services/auth_service.dart';
import 'package:petcoin/services/currency_service.dart';
import 'package:petcoin/services/firebase_services.dart';
import 'package:settings_ui/settings_ui.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final User? user = AuthService().currentUser;
  String _userCurrency = '';
  List<String> currencies = CurrencyService().getAvailableCurrencies;
  String selectedCurrency = 'NTD';
  bool areNotificationsEnabled = true;

  Future<void> _signOut() async {
    await AuthService().signOut();
  }

  Future<void> _getUserCurrency() async {
    _userCurrency = await FirebaseService().getUserCurrency();
    setState(() {});
  }

  Future<void> _updateUserCurrency(String newCurrency) async {
    String oldCurrency = await FirebaseService().getUserCurrency();
    setState(() {
      _userCurrency = newCurrency;
    });
    await FirebaseService().updateUserCurrency(oldCurrency, newCurrency);
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
      value: Row(
        children: [
          Text(_userCurrency),
          _currencyTrailing(),
        ],
      ),
    );
  }

  Widget _currencyTrailing() {
    return PopupMenuButton(
      icon: Icon(Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.secondary),
      iconSize: 30,
      onSelected: (value) {
        setState(() {
          _userCurrency = value;
          _updateUserCurrency(value);
        });
      },
      itemBuilder: (_) => currencies
          .map(
            (e) => PopupMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S E T T I N G'),
      ),
      backgroundColor: Colors.white,
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
            ],
          ),
          SettingsSection(
            tiles: [
              SettingsTile(
                title: Text('Logout'),
                onPressed: (context) => _signOut(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
