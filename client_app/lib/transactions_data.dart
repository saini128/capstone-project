import 'package:intl/intl.dart';

class TransactionData {
  DateTime startTime;
  DateTime endTime;
  bool isOngoing;
  double finalAmount;

  TransactionData(
      this.startTime, this.endTime, this.isOngoing, this.finalAmount);
}

void createInitialData() {
  List<TransactionData> TransactionDatas = [
    TransactionData(DateTime(2023, 10, 16, 9, 0),
        DateTime(2023, 10, 16, 10, 30), true, 0.0),
    TransactionData(DateTime(2023, 10, 17, 14, 0),
        DateTime(2023, 10, 17, 16, 0), false, 0.0),
    TransactionData(DateTime(2023, 10, 18, 19, 30),
        DateTime(2023, 10, 18, 20, 45), true, 0.0),
    TransactionData(DateTime(2023, 10, 19, 11, 0),
        DateTime(2023, 10, 19, 12, 15), false, 0.0),
    TransactionData(DateTime(2023, 10, 20, 16, 30),
        DateTime(2023, 10, 20, 18, 0), true, 0.0),
  ];

  for (TransactionData TransactionData in TransactionDatas) {
    Duration difference =
        TransactionData.endTime.difference(TransactionData.startTime);
    double minutesDifference = difference.inMinutes.toDouble();
    double finalAmount = 0.5 * minutesDifference;
    TransactionData.finalAmount = finalAmount;
  }
}
