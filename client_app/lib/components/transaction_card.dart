import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TransactionCard extends StatefulWidget {
  final bool inprogress;
  final DateTime start;
  final DateTime end;
  final Color color; //=DateTime.now();

  TransactionCard(
      {Key? key,
      required this.inprogress,
      required this.end,
      required this.color,
      required this.start})
      : super(key: key);

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  final Stopwatch stopwatch = Stopwatch()..start();
  int elapsedSeconds = 0;
  int elapsedMinutes = 0;
  int amount = 45; // = widget.end.difference(widget.start).inMinutes;

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
    return Card(
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: widget.inprogress
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
                    child: widget.inprogress
                        ? Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(widget.start))
                        : Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(widget.end)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: widget.inprogress
                        ? Text('$elapsedMinutes min $elapsedSeconds sec')
                        : Text('\u{20B9}$amount'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
