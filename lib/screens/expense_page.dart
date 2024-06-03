import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcoin/services/firebase_services.dart';
import 'package:petcoin/services/expense_item.dart';
import 'package:petcoin/services/reminder_service.dart';
import 'package:petcoin/widget/expense_tile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  DateTime selectedDate = DateTime.now();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('H O M E'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewExpense(context);
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<ExpenseItem>>(
        stream: _firebaseService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expenses found'));
          } else {
            final expenses = snapshot.data!;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseTile(
                  expense: expenses[index],
                  onDelete: () =>
                      _firebaseService.deleteExpense(expenses[index].id),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<dynamic> addNewExpense(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.list),
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                hintText: 'Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => cancel(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => save(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
      selectedDate = picked;
    });
  }

  save(BuildContext context) {
    if (_nameController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      ExpenseItem newExpenseItem = ExpenseItem(
        id: _firebaseService.getId(),
        name: _nameController.text,
        amount: _amountController.text,
        dateTime: DateTime.parse(_dateController.text),
      );

      _firebaseService.addExpense(newExpenseItem);

      Navigator.pop(context);

      clear();
    }
  }

  cancel(BuildContext context) {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    _nameController.clear();
    _amountController.clear();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
