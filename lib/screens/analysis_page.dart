import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:petcoin/models/expense_item.dart';
import 'package:petcoin/services/firebase_services.dart';

class ExpenseIncomePieChart extends StatefulWidget {
  @override
  State<ExpenseIncomePieChart> createState() => _ExpenseIncomePieChartState();
}

class _ExpenseIncomePieChartState extends State<ExpenseIncomePieChart> {
  double _total = 10.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  Future<List<ExpenseItem>> _expenses = Future.value([]);
  Future<List<ExpenseItem>> _incomes = Future.value([]);
  String selectedCategory = 'All';
  String _userCurrency = '';

  final _firebaseService = FirebaseService();

  Future<void> _getTotalIncomeAndExpense() async {
    final totalIncome = await _firebaseService.getTotalIncome();
    final totalExpense = await _firebaseService.getTotalExpense();
    final total = totalExpense + totalIncome;
    final expenses = _firebaseService.getExpensesByCategory(selectedCategory);
    final incomes = _firebaseService.getIncomesByCategory(selectedCategory);
    String userCurrency = await _firebaseService.getUserCurrency();
    setState(() {
      _totalIncome = totalIncome;
      _totalExpense = totalExpense;
      _total = total;
      _expenses = expenses;
      _incomes = incomes;
      _userCurrency = userCurrency;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTotalIncomeAndExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A N A L Y S I S'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.red,
                    value: _totalExpense / _total,
                    title: 'Expense: ${_totalExpense.toStringAsFixed(2)}',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: _totalIncome / _total,
                    title: 'Income: ${_totalIncome.toStringAsFixed(2)}',
                    radius: 60,
                  ),
                ],
                borderData: FlBorderData(
                  show: false,
                ),
                centerSpaceRadius: 40,
              ),
            ),
          ),
          Text(
            'Expenses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<ExpenseItem>>(
              future: _expenses,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  final expenses = snapshot.data!;

                  // Display expenses using ListView or appropriate widget
                  return ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        title: Text(expense.name),
                        subtitle: Text(
                            '$_userCurrency ${expense.amount} - ${expense.category} - ${DateFormat('yyyy-MM-dd').format(expense.dateTime)}'),
                      );
                    },
                  );
                }

                // Display loading indicator while data is being fetched
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Text(
            'Incomes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder<List<ExpenseItem>>(
              future: _incomes,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  final incomes = snapshot.data!;

                  // Display expenses using ListView or appropriate widget
                  return ListView.builder(
                    itemCount: incomes.length,
                    itemBuilder: (context, index) {
                      final expense = incomes[index];
                      return ListTile(
                        title: Text(expense.name),
                        subtitle: Text(
                            '$_userCurrency ${expense.amount} - ${expense.category} - ${DateFormat('yyyy-MM-dd').format(expense.dateTime)}'),
                      );
                    },
                  );
                }

                // Display loading indicator while data is being fetched
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
