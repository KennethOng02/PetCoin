import 'package:flutter/material.dart';
import 'package:petcoin/model/expense_item.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '/services/currency_service.dart';
import 'package:petcoin/services/reminder_service.dart';

class HomePage extends StatefulWidget {
  final ReminderService reminderService;

  HomePage({required this.reminderService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final reminderController = TextEditingController();
  String _selectedCurrency = 'USD';
  bool isExpense = false;
  final CurrencyService _currencyService = CurrencyService();
  int _reminderInterval = 60; // 初始化提醒時間為 60 分鐘

  List<String> currencies = ['USD', 'EUR', 'JPY'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('New Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icon(Icons.list),
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      hintText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ToggleSwitch(
                      minWidth: 90.0,
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      cornerRadius: 20.0,
                      labels: ['Income', 'Expense'],
                      onToggle: (index) {
                        isExpense = (index == 1) ? true : false;
                      },
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedCurrency,
                    items: currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    nameController.clear();
                    amountController.clear();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    if (nameController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      ExpenseItem newExpenseItem = ExpenseItem(
                        name: nameController.text,
                        amount: amountController.text,
                        isExpense: isExpense,
                        dateTime: DateTime.now(),
                        currency: _selectedCurrency,
                      );

                      // Save to db
                      setState(() {
                        items.add(newExpenseItem);
                      });

                      // dispose controller
                      nameController.clear();
                      amountController.clear();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: reminderController,
                    decoration: InputDecoration(
                      labelText: '設定提醒時間 (分鐘)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final minutes = int.tryParse(reminderController.text);
                    if (minutes != null) {
                      widget.reminderService.updateReminderInterval(minutes);
                      setState(() {
                        _reminderInterval = minutes; // 更新提醒時間
                      });
                    }
                  },
                  child: Text('確定'),
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     '下一次提醒：${_formatDuration(Duration(seconds: widget.reminderService.reminderInterval * 60))}',
          //     style: TextStyle(fontSize: 16, color: Colors.red),
          //   ),
          // ),
          DropdownButton<String>(
            value: _selectedCurrency,
            items: <String>['USD', 'EUR', 'JPY', 'CNY'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCurrency = newValue!;
              });
            },
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  title: Text(items[index].name),
                  subtitle: Text(
                      '${items[index].dateTime.day}/${items[index].dateTime.month}/${items[index].dateTime.year}'),
                  trailing: FutureBuilder<double>(
                    future: _currencyService.convert(
                        double.parse(items[index].amount), items[index].currency, _selectedCurrency),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text('${snapshot.data!.toStringAsFixed(2)} $_selectedCurrency');
                      }
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
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
