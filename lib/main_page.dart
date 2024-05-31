import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:petcoin/screens/home_page.dart';
import 'package:petcoin/screens/notificationpage.dart';
import 'services/reminder_service.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final List<String> _notifications = [];
  late ReminderService _reminderService;
  List<Widget> _pages = [];
  int _remainingTime = 0;
  bool _hasNewNotification = false;

  @override
  void initState() {
    super.initState();
    _reminderService = ReminderService(
      onReminder: _addNotification,
      onTick: _updateRemainingTime,
    );
    _reminderService.startReminder(60);
    _pages = [
      HomePage(reminderService: _reminderService),
      Placeholder(),
      Placeholder(),
      NotificationPage(notifications: _notifications),
      Placeholder(),
    ];
  }

  void _addNotification(String message) {
    setState(() {
      _notifications.add(message);
      _hasNewNotification = true;
    });
  }

  void _updateRemainingTime(int remainingTime) {
    setState(() {
      _remainingTime = remainingTime;
      if (_remainingTime == 0 && _notifications.isNotEmpty) {
        _hasNewNotification = true;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        _hasNewNotification = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(child: _pages[_selectedIndex]),
            if (_selectedIndex == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '下一次提醒：${_formatDuration(Duration(seconds: _remainingTime))}',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
          ],
        ),
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
                    icon: _hasNewNotification ? Icons.notifications_active : Icons.notifications_none_outlined,
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
