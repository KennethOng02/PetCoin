import 'package:flutter/material.dart';
import 'package:petcoin/model/expense_item.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  bool isExpense = false;

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
                  trailing: Text('\$${items[index].amount}'),
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
}
