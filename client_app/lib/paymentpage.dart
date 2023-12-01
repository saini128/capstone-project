import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:payment_sheet/payment_sheet.dart';


class PaymentPage extends StatefulWidget {
  final double amount;

  const PaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = 'your_publishable_key'; // Replace with your Stripe publishable key
  }

  Future<void> _handleCardPayment() async {
    // Implement card payment logic using the flutter_stripe package
    // Check the package documentation for more details
  }

  Future<void> _handlePaymentSheet() async {
    // Implement payment sheet logic using the payment_sheet package
    // Check the package documentation for more details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleCardPayment,
              child: Text('Card Payment'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handlePaymentSheet,
              child: Text('Payment Sheet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement Google Pay logic
              },
              child: Text('Google Pay'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('PhonePe'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Paytm'),
            ),
          ],
        ),
      ),
    );
  }
}
