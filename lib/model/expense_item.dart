class ExpenseItem {
  String name;
  String amount;
  bool isExpense;
  DateTime dateTime;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.isExpense,
    required this.dateTime,
  });
}

List<ExpenseItem> items = [
  ExpenseItem(
    name: 'coffee',
    amount: '45',
    isExpense: true,
    dateTime: DateTime.now(),
  ),
  ExpenseItem(
    name: 'brunch',
    amount: '120',
    isExpense: true,
    dateTime: DateTime.now(),
  ),
  ExpenseItem(
    name: 'transportation',
    amount: '15',
    isExpense: true,
    dateTime: DateTime.now(),
  ),
  ExpenseItem(
    name: 'entertainment',
    amount: '300',
    isExpense: true,
    dateTime: DateTime.now(),
  ),
  ExpenseItem(
    name: 'dinner',
    amount: '150',
    isExpense: true,
    dateTime: DateTime.now(),
  ),
];
