import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionData {
  DateTime startTime;
  DateTime endTime;
  bool isOngoing;
  double finalAmount;

  TransactionData(
      this.startTime, this.endTime, this.isOngoing, this.finalAmount);

  // Convert TransactionData to a Map for Firestore
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

  // Create a TransactionData object from Firestore data
  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
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
      TransactionData transactionData, String email) async {
    await _firestore
        .collection('users')
        .doc(email)
        .collection('transactions')
        .add(
          transactionData.toMap(),
        );
  }

  Future<List<TransactionData>> getTransactions(String email) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(email)
        .collection('transactions')
        .get();

    return querySnapshot.docs
        .map((doc) =>
            TransactionData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateTransaction(String transactionId,
      TransactionData updatedTransaction, String email) async {
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
