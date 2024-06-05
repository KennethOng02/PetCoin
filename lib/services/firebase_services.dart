import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/services/auth_service.dart';
import 'package:petcoin/services/currency_service.dart';
import 'package:petcoin/models/expense_item.dart';

class FirebaseService {
  final _expensesCollection = FirebaseFirestore.instance.collection('expenses');

  final _incomesCollection = FirebaseFirestore.instance.collection('incomes');

  final User? _user = AuthService().currentUser;

  String get getId => _expensesCollection.doc().id;

  Future<String> getUserCurrency() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get();
    return userDoc['currency'];
  }

  Future<void> addExpense(ExpenseItem expense) async {
    try {
      final subExpensescollection =
          _expensesCollection.doc(_user!.uid).collection('expense');

      await subExpensescollection.add({
        'id': expense.id,
        'name': expense.name,
        'amount': expense.amount,
        'dateTime': expense.dateTime,
        'category': expense.category,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addIncome(ExpenseItem expense) async {
    try {
      final subIncomescollection =
          _incomesCollection.doc(_user!.uid).collection('income');

      await subIncomescollection.add({
        'id': expense.id,
        'name': expense.name,
        'amount': expense.amount,
        'dateTime': expense.dateTime,
        'category': expense.category,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<ExpenseItem>> getExpenses() {
    final subExpensescollection =
        _expensesCollection.doc(_user!.uid).collection('expense');

    return subExpensescollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseItem(
          id: doc.id,
          name: doc['name'],
          amount: doc['amount'],
          category: doc['category'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  Stream<List<ExpenseItem>> getIncomes() {
    final subIncomescollection =
        _incomesCollection.doc(_user!.uid).collection('income');

    return subIncomescollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseItem(
          id: doc.id,
          name: doc['name'],
          amount: doc['amount'],
          category: doc['category'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  Future<double> getTotalExpense() async {
    final subExpensescollection =
        _expensesCollection.doc(_user!.uid).collection('expense');

    final snapshot = await subExpensescollection.get();

    // Proceed with calculating total expense after data is fetched
    return calculateTotalExpense(snapshot.docs);
  }

  Future<double> getTotalIncome() async {
    final subIncomescollection =
        _incomesCollection.doc(_user!.uid).collection('income');

    final snapshot = await subIncomescollection.get();

    // Proceed with calculating total expense after data is fetched
    return calculateTotalExpense(snapshot.docs);
  }

  double calculateTotalExpense(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    double totalExpense = 0.0;
    for (var doc in documents) {
      final expenseItem = ExpenseItem.fromMap(doc.data());
      final amount = double.tryParse(expenseItem.amount) ?? 0.0;
      totalExpense += amount;
    }
    return totalExpense;
  }

  Future<List<ExpenseItem>> getExpensesByCategory(String category) async {
    final expenses = <ExpenseItem>[];

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference userItemsCollection = firestore
          .collection('expenses')
          .doc(_user!.uid)
          .collection('expense');

      QuerySnapshot userItemsSnapshot = await userItemsCollection.get();
      for (final queryDocSnapshot in userItemsSnapshot.docs) {
        final expense = ExpenseItem.fromDocument(queryDocSnapshot);
        expenses.add(expense);
      }

      return expenses;
    } catch (error) {
      // Handle errors appropriately (e.g., logging, showing user messages)
      print('Error fetching expenses: $error');
      return []; // Return an empty list on error
    }
  }

  Future<List<ExpenseItem>> getIncomesByCategory(String category) async {
    final incomes = <ExpenseItem>[];

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference userItemsCollection =
          firestore.collection('incomes').doc(_user!.uid).collection('income');

      QuerySnapshot userItemsSnapshot = await userItemsCollection.get();
      for (final queryDocSnapshot in userItemsSnapshot.docs) {
        final expense = ExpenseItem.fromDocument(queryDocSnapshot);
        incomes.add(expense);
      }

      return incomes;
    } catch (error) {
      // Handle errors appropriately (e.g., logging, showing user messages)
      print('Error fetching expenses: $error');
      return []; // Return an empty list on error
    }
  }

  // UPDATE
  Future<void> updateUserCurrency(
      String oldCurrency, String newCurrency) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(_user!.uid);
    await updateExpenses(oldCurrency, newCurrency);
    await updateIncomes(oldCurrency, newCurrency);
    await userDoc.update({
      'currency': newCurrency,
    });
  }

  Future<void> updateExpenses(String fromCurrency, String toCurrency) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = FirebaseFirestore.instance.batch();

    CollectionReference userItemsCollection =
        firestore.collection('expenses').doc(_user!.uid).collection('expense');

    QuerySnapshot userItemsSnapshot = await userItemsCollection.get();

    for (var itemDoc in userItemsSnapshot.docs) {
      ExpenseItem expenseItem = ExpenseItem.fromDocument(itemDoc);

      double currentAmount = double.parse(expenseItem.amount);
      double updatedAmount = await CurrencyService()
          .convert(currentAmount, fromCurrency, toCurrency);

      batch.update(itemDoc.reference, {
        'amount': updatedAmount.toStringAsFixed(2),
      });
    }
    await batch.commit();
  }

  Future<void> updateIncomes(String fromCurrency, String toCurrency) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = FirebaseFirestore.instance.batch();

    CollectionReference userItemsCollection =
        firestore.collection('incomes').doc(_user!.uid).collection('income');

    QuerySnapshot userItemsSnapshot = await userItemsCollection.get();

    for (var itemDoc in userItemsSnapshot.docs) {
      ExpenseItem expenseItem = ExpenseItem.fromDocument(itemDoc);

      double currentAmount = double.parse(expenseItem.amount);
      double updatedAmount = await CurrencyService()
          .convert(currentAmount, fromCurrency, toCurrency);

      batch.update(itemDoc.reference, {
        'amount': updatedAmount.toStringAsFixed(2),
      });
    }
    await batch.commit();
  }

  // DELETE
  Future<void> deleteExpense(String id) async {
    final subExpensescollection =
        _expensesCollection.doc(_user!.uid).collection('expense');

    try {
      final documentRef = subExpensescollection.doc(id);
      await documentRef.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteIncome(String id) async {
    final subIncomescollection =
        _incomesCollection.doc(_user!.uid).collection('income');

    try {
      final documentRef = subIncomescollection.doc(id);
      await documentRef.delete();
    } catch (e) {
      print(e);
    }
  }
}
