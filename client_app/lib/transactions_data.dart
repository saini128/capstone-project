import 'package:intl/intl.dart';
import 'firebase_transactions_data.dart';

class TransactionData {
  DateTime startTime;
  DateTime endTime;
  bool isOngoing;
  double finalAmount;

  TransactionData(
      this.startTime, this.endTime, this.isOngoing, this.finalAmount);
}

class database {
  List<TransactionData> TransactionDatas = [];
  void createInitialData(String email) {
    TransactionDatas = [
      TransactionData(DateTime(2023, 10, 16, 9, 0),
          DateTime(2023, 10, 16, 10, 30), false, 45.0),
      TransactionData(DateTime(2023, 10, 17, 14, 0),
          DateTime(2023, 10, 17, 16, 0), false, 75.0),
      TransactionData(DateTime(2023, 10, 18, 19, 30),
          DateTime(2023, 10, 18, 20, 45), false, 80.0),
      TransactionData(DateTime(2023, 10, 19, 11, 0),
          DateTime(2023, 10, 19, 12, 15), false, 40.0),
      TransactionData(DateTime(2023, 10, 20, 16, 30),
          DateTime(2023, 10, 20, 18, 0), false, 35.0),
    ];
    // Database db = Database();
    // TransactionDatas = db.getTransactions(email) as List<TransactionData>;

    for (TransactionData TransactionDatam in TransactionDatas) {
      TransactionDatam.finalAmount = 0.5 *
          TransactionDatam.endTime
              .difference(TransactionDatam.startTime)
              .inMinutes;
      print(TransactionDatam.finalAmount);
    }
    //List<TransactionData> get registeredEvents => TransactionDatas;
  }
}
