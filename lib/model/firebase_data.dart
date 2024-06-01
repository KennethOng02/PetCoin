import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcoin/model/auth.dart';
import 'package:petcoin/model/expense_item.dart';

class FirebaseService {
  final CollectionReference _expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final User? user = Auth().currentUser;

  String getId() {
    return _expensesCollection.doc().id;
  }

  Future<void> addExpense(ExpenseItem expense) async {
    try {
      final String userId = user!.uid;
      final subExpensescollection =
          _expensesCollection.doc(userId).collection('expenses');

      // await _expensesCollection.add({
      //   'name': expense.name,
      //   'amount': expense.amount,
      //   'dateTime': expense.dateTime,
      // });
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
