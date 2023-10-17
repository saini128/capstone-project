import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionCard extends StatefulWidget {
  final bool inprogress;
  final DateTime start;
  const TransactionCard(
      {super.key, required this.inprogress, required this.start});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                    child: Text('data'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('data'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: Text('data'),
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
