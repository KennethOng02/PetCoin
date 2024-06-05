import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:petcoin/screens/analysis_page.dart';
import 'package:petcoin/screens/income_expense_page.dart';
import 'package:petcoin/services/auth_service.dart';
import 'package:petcoin/screens/notificationpage.dart';
import 'package:petcoin/screens/pet_page.dart';
import 'package:petcoin/screens/user_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Widget> _pages = [
    IncomeExpensePage(),
    ExpenseIncomePieChart(),
    PetPage(),
    NotificationPage(),
    UserSettingsPage(),
  ];

  final User? user = AuthService().currentUser;

  Future<void> signOut() async {
    await AuthService().signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.black,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8,
              ),
              child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                padding: EdgeInsets.all(16),
                duration: Duration(milliseconds: 400),
                tabBorderRadius: 20,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.analytics_sharp,
                    text: 'Analytics',
                  ),
                  GButton(
                    icon: Icons.videogame_asset,
                    text: 'Game',
                  ),
                  GButton(
                    icon: Icons.notifications_none_outlined,
                    text: 'Notification',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
