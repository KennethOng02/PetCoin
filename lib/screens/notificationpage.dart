import 'package:flutter/material.dart';
import 'package:petcoin/services/reminder_service.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _reminderController = TextEditingController();
  int _reminderInterval = 60; // 初始化提醒時間為 60 分鐘
  final List<String> _notifications = [];
  late ReminderService _reminderService;
  int _remainingTime = 0;
  bool _hasNewNotification = false;

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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();

    _reminderService = ReminderService(
      onReminder: _addNotification,
      onTick: _updateRemainingTime,
    );

    _reminderService.startReminder(60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('N O T I F I C A T I O N'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reminderController,
                    decoration: InputDecoration(
                      labelText: 'Set Reminder Time(minute)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final minutes = int.tryParse(_reminderController.text);
                    if (minutes != null) {
                      _reminderService.updateReminderInterval(minutes);
                      setState(() {
                        _reminderInterval = minutes; // 更新提醒時間
                      });
                    }
                  },
                  child: Text('SET'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '提醒週期：${_formatDuration(Duration(minutes: _reminderInterval))}',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.message),
                    title: Text(
                      _notifications[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: _notifications.length),
          ),
        ],
      ),
    );
  }
}
