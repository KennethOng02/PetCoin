import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcoin/models/expense_item.dart';
import 'package:petcoin/services/firebase_services.dart';

class ExpenseTile extends StatefulWidget {
  final ExpenseItem expense;
  final Future<void> Function() onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  String? _userCurrency;

  Future<void> _getUserCurrency() async {
    String userCurrency = await FirebaseService().getUserCurrency();
    setState(() {
      _userCurrency = userCurrency;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.expense.name),
      subtitle: Row(
        children: [
          Text(widget.expense.category),
          const SizedBox(width: 5),
          Text(DateFormat('yyyy-MM-dd').format(widget.expense.dateTime)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$_userCurrency ${widget.expense.amount}'),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => widget.onDelete(),
          ),
        ],
      ),
    );
  }
}
