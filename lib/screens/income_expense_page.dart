import 'package:flutter/material.dart';
import 'package:petcoin/screens/expense_page.dart';
import 'package:petcoin/screens/income_page.dart';

class IncomeExpensePage extends StatefulWidget {
  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  int tabIndex = 1;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tabIndex,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('P E T C O I N'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IncomePage(),
            ExpensePage(),
          ],
        ),
      ),
    );
  }
}
