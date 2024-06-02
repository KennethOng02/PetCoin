import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseItem {
  String id;
  String name;
  String amount;
  DateTime dateTime;

  ExpenseItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static ExpenseItem fromMap(Map<String, dynamic> map) {
    return ExpenseItem(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  factory ExpenseItem.fromDocument(DocumentSnapshot doc) {
    return ExpenseItem(
      id: doc.id,
      name: doc['name'],
      amount: doc['amount'],
      dateTime: (doc['dateTime'] as Timestamp).toDate(),
    );
  }
}
