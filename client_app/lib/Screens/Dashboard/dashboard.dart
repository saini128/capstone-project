import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  final String name;
  int dueAmount;
  bool isRentingCycle;

  DashboardPage({
    Key? key,
    required this.name,
    required this.dueAmount,
    this.isRentingCycle = false,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _scanBarcode = 'Unknown';
  bool _dataFetched = false;
  bool _donescanning = true;

  @override
  void initState() {
    super.initState();
    // Fetch the initial renting status when the widget is initialized
    getInitialRentingStatus();
  }

  Future<void> getInitialRentingStatus() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.thingspeak.com/channels/2304645/fields/1.json?results=1',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['feeds'] != null && jsonResponse['feeds'].isNotEmpty) {
          final lastEntry = jsonResponse['feeds'].last;
          final field1Value = lastEntry['field1'];
          setState(() {
            widget.isRentingCycle = (field1Value == '1');
            _dataFetched = true;
          });
        }
      }
    } catch (e) {
      print('Failed to fetch initial renting status: $e');
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    if (!_donescanning) return; // Avoid multiple scan attempts
    //await Future.delayed(Duration(seconds: 2));
    setState(() {
      _donescanning = false; // Mark that scanning is in progress
    });

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() async {
      _donescanning = true;
      Uri url;
      _scanBarcode = barcodeScanRes;
      if (widget.isRentingCycle) {
        url = Uri.parse(
          'https://api.thingspeak.com/update?api_key=O6Q91SERUAB4JDIF&field1=0',
        );
      } else {
        url = Uri.parse(
          'https://api.thingspeak.com/update?api_key=O6Q91SERUAB4JDIF&field1=1',
        );
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Data sent to ThingSpeak: ${!widget.isRentingCycle}');
      } else {
        print('Failed to send data to ThingSpeak');
      }

      setState(() {
        widget.isRentingCycle =
            !widget.isRentingCycle; // Update the isRentingCycle
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: (_dataFetched && _donescanning)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome, ${widget.name}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Current Status: ${widget.isRentingCycle ? "Rented" : "Not Rented"}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Due: \$${widget.dueAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: scanQR, // Call the scanQR method
                    child: Text('Scan QR Code'),
                  ),
                ],
              )
            : CircularProgressIndicator(), // Show a loading indicator until data is fetched
      ),
    );
  }
}
