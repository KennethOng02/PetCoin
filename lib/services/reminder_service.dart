import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;
  int _reminderInterval = 60; // 默認提醒間隔，單位為分鐘
  Function(String)? onReminder; // 回調函數
  Function(int)? onTick; // 計時回調函數

  ReminderService({this.onReminder, this.onTick}) {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      '記帳提醒',
      '該記錄你的開銷了！',
      platformChannelSpecifics,
      payload: 'item x',
    );

    // 调用回调函数，更新通知页面
    if (onReminder != null) {
      onReminder!('該記錄你的開銷了！');
    }
  }

  void startReminder(int minutes) {
    _reminderInterval = minutes;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final remainingTime = _reminderInterval * 60 - timer.tick;
      if (remainingTime <= 0) {
        _showNotification();
        timer.cancel();
        startReminder(_reminderInterval); // 重新開始計時
      } else {
        if (onTick != null) {
          onTick!(remainingTime);
        }
      }
    });
  }

  void stopReminder() {
    _timer?.cancel();
  }

  int get reminderInterval => _reminderInterval;

  void updateReminderInterval(int minutes) {
    startReminder(minutes);
  }
}
