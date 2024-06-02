import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/services/auth.dart';
import 'package:petcoin/services/currency_service.dart';
import 'package:petcoin/services/expense_item.dart';

class FirebaseService {
  final CollectionReference _expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final User? user = Auth().currentUser;

  String getId() {
    return _expensesCollection.doc().id;
  }

  Future<String> getUserCurrency() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userDoc['currency'];
  }

  Future<void> updateUserCurrency(
      String oldCurrency, String newCurrency) async {
    final String userId = user!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await updateAmounts(oldCurrency, newCurrency);
    await userDoc.update({
      'currency': newCurrency,
    });
  }

  Future<void> addExpense(ExpenseItem expense) async {
    try {
      final String userId = user!.uid;
      final subExpensescollection =
          _expensesCollection.doc(userId).collection('expenses');

      await subExpensescollection.add({
        'name': expense.name,
        'amount': expense.amount,
        'dateTime': expense.dateTime,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<ExpenseItem>> getExpenses() {
    final String userId = user!.uid;
    final subExpensescollection =
        _expensesCollection.doc(userId).collection('expenses');
    return subExpensescollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseItem(
          id: doc.id,
          name: doc['name'],
          amount: doc['amount'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateAmounts(String fromCurrency, String toCurrency) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String userId = user!.uid;
    WriteBatch batch = firestore.batch();

    CollectionReference userItemsCollection =
        firestore.collection('expenses').doc(userId).collection('expenses');
    QuerySnapshot userItemsSnapshot = await userItemsCollection.get();

    for (var itemDoc in userItemsSnapshot.docs) {
      ExpenseItem expenseItem = ExpenseItem.fromDocument(itemDoc);

      double currentAmount = double.parse(expenseItem.amount);
      double updatedAmount = await CurrencyService()
          .convert(currentAmount, fromCurrency, toCurrency);

      batch.update(itemDoc.reference, {
        'amount': updatedAmount.toString(),
      });
    }
    await batch.commit();
  }

  // DELETE
  Future<void> deleteExpense(String id) async {
    final String userId = user!.uid;
    final subExpensescollection =
        _expensesCollection.doc(userId).collection('expenses');
    try {
      final documentRef = subExpensescollection.doc(id);
      await documentRef.delete();
    } catch (e) {
      print(e);
    }
  }
}
