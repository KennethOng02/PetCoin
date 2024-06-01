import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcoin/model/expense_item.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseItem expense;
  final Future<void> Function() onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.name),
      subtitle: Text(DateFormat('yyyy-MM-dd').format(expense.dateTime)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('NTD ${expense.amount}'),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(),
          ),
        ],
      ),
    );
  }
}
