import 'package:client_app/Screens/Dashboard/maps.dart';
import 'package:client_app/transactions_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TransactionCard extends StatefulWidget {
  final TransactionData datam;
  final Color color; //=DateTime.now();

  TransactionCard({Key? key, required this.color, required this.datam})
      : super(key: key);

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  final Stopwatch stopwatch = Stopwatch()..start();
  int elapsedSeconds = 0;
  int elapsedMinutes = 0;

  _TransactionCardState() {
    // Create a timer to update the elapsed time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds = stopwatch.elapsed.inSeconds;
        elapsedMinutes = elapsedSeconds ~/ 60;
        elapsedSeconds %= 60;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapScreen();
            },
          ),
        );
      },
      child: Card(
        color: widget.color,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                child: SvgPicture.asset('assets/icons/bike.svg'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: widget.datam.isOngoing
                          ? Text(
                              'Ongoing Ride',
                              style: TextStyle(color: Colors.red),
                            )
                          : Text(
                              'Ride Completed',
                              style: TextStyle(color: Colors.green),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: widget.datam.isOngoing
                          ? Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(widget.datam.startTime))
                          : Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(widget.datam.endTime)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: widget.datam.isOngoing
                          ? Text('$elapsedMinutes min $elapsedSeconds sec')
                          : Text(
                              '\u{20B9}' + widget.datam.finalAmount.toString()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
