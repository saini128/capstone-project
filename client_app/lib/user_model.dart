import 'dart:ffi';

class User {
  User({
    required this.name,
    required this.dueAmount,
    required this.isRentingCycle,
  });
  final String name;
  final int dueAmount;
  final bool isRentingCycle;
}
