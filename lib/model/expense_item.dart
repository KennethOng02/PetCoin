class ExpenseItem {
  String name;
  String amount;
  bool isExpense;
  DateTime dateTime;
  String currency;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.isExpense,
    required this.dateTime,
    required this.currency,
  });
}

List<ExpenseItem> items = [
  ExpenseItem(
    name: 'coffee',
    amount: '45',
    isExpense: true,
    dateTime: DateTime.now(),
    currency: 'USD',
  ),
  ExpenseItem(
    name: 'brunch',
    amount: '120',
    isExpense: true,
    dateTime: DateTime.now(),
    currency: 'USD',
  ),
  ExpenseItem(
    name: 'transportation',
    amount: '15',
    isExpense: true,
    dateTime: DateTime.now(),
    currency: 'USD',
  ),
  ExpenseItem(
    name: 'entertainment',
    amount: '300',
    isExpense: true,
    dateTime: DateTime.now(),
    currency: 'USD',
  ),
  ExpenseItem(
    name: 'dinner',
    amount: '150',
    isExpense: true,
    dateTime: DateTime.now(),
    currency: 'USD',
  ),
];
