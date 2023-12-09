import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDatam {
  DateTime startTime;
  DateTime endTime;
  bool isOngoing;
  double finalAmount;

  TransactionDatam(
      this.startTime, this.endTime, this.isOngoing, this.finalAmount);

  // Convert TransactionDatam to a Map for Firestore
  Map<String, dynamic> toMap() {
    // Automatically calculate finalAmount before storing in Firestore
    finalAmount = 0.5 * endTime.difference(startTime).inMinutes.toDouble();

    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'isOngoing': isOngoing,
      'finalAmount': finalAmount,
    };
  }

  // Create a TransactionDatam object from Firestore data
  factory TransactionDatam.fromMap(Map<String, dynamic> map) {
    return TransactionDatam(
      (map['startTime'] as Timestamp).toDate(),
      (map['endTime'] as Timestamp).toDate(),
      map['isOngoing'] as bool,
      map['finalAmount'] as double,
    );
  }
}

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction(
      TransactionDatam TransactionDatam, String email) async {
    await _firestore
        .collection('users')
        .doc(email)
        .collection('transactions')
        .add(
          TransactionDatam.toMap(),
        );
  }

  Future<List<TransactionDatam>> getTransactions(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(email)
        .collection('transactions')
        .get();

    return querySnapshot.docs
        .map((doc) =>
            TransactionDatam.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTransaction(String transactionId,
      TransactionDatam updatedTransaction, String email) async {
    await _firestore
        .collection('users')
        .doc(email)
        .collection('transactions')
        .doc(transactionId)
        .update(
          updatedTransaction.toMap(),
        );
  }
}
