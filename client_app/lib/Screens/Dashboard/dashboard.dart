import 'dart:async';
import 'dart:convert';
import 'package:client_app/components/transaction_card.dart';
import 'package:client_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  final String name;
  int dueAmount;
  bool isRentingCycle;
  final Color overlayColor;
  final double opacity;
  final Color progressIndicatorColor;

  DashboardPage({
    Key? key,
    required this.name,
    required this.dueAmount,
    this.isRentingCycle = false,
    this.overlayColor = Colors.grey,
    this.opacity = 0.7,
    this.progressIndicatorColor = Colors.white,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //String _scanBarcode = 'Unknown';
  bool _dataFetched = false;
  bool _scanning = false;

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
          'https://api.thingspeak.com/channels/2304645/fields/1.json?results=2',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['feeds'] != null && jsonResponse['feeds'].isNotEmpty) {
          final lastEntry = jsonResponse['feeds'].last;
          final field1Value = lastEntry['field1'];
          setState(() {
            widget.isRentingCycle = (field1Value == '1');
            print('FIeld 1 Value = ' + field1Value);
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
    //if (!_scanning) return; // Avoid multiple scan attempts
    //await Future.delayed(Duration(seconds: 2));

    _scanning = true; // Mark that scanning is in progress
    setState(() {});
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

    if (barcodeScanRes == "68354") {
      Uri url;
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
        setState(() {
          widget.isRentingCycle =
              !widget.isRentingCycle; // Update the isRentingCycle
        });
      } else {
        print('Failed to send data to ThingSpeak');
      }
    } else
      print('wrong QR');
    _scanning = false;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 244, 248),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 244, 248),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: openDrawer,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Menu Item 1"),
              onTap: () {
                // Handle menu item 1 click
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Menu Item 2"),
              onTap: () {
                // Handle menu item 2 click
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            if (!_dataFetched || _scanning)
              Container(
                alignment: Alignment.center,
                height: 600,
                color: widget.overlayColor.withOpacity(widget.opacity),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        widget.progressIndicatorColor),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                        child: Text(
                          'Welcome,',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text('Hushraj Singh',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: kPrimaryColor,
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.pin_drop,
                        color: Color.fromARGB(255, 63, 63, 63),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Text(
                          'Patiala, Punjab',
                          style: TextStyle(
                              color: Color.fromARGB(255, 63, 63, 63),
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: !_dataFetched || _scanning
                          ? widget.overlayColor.withOpacity(widget.opacity)
                          : Color.fromARGB(255, 244, 244, 244),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due: \$100.00', // Replace with your actual amount due
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: 300,
                              child: Text(
                                (widget.isRentingCycle
                                    ? 'Cycle Status: Rented'
                                    : 'Cycle Status: Not Rented'), // Replace with your actual cycle status
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          scanQR();
                          _scanning = true;
                          //setState(() {});
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          // color: Color.fromARGB(255, 244, 244, 244),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            height: 70,
                            width: 70,
                            color: !_dataFetched || _scanning
                                ? widget.overlayColor
                                    .withOpacity(widget.opacity)
                                : Color.fromARGB(255, 244, 233, 255),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SvgPicture.asset("assets/images/qr.svg"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: () {
                          getInitialRentingStatus();
                          setState(() {});
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          // color: Color.fromARGB(255, 244, 244, 244),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            height: 70,
                            width: 70,
                            color: !_dataFetched || _scanning
                                ? widget.overlayColor
                                    .withOpacity(widget.opacity)
                                : Color.fromARGB(255, 244, 233, 255),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child:
                                  SvgPicture.asset("assets/images/rupee.svg"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ride Details',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w500),
                        ))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TransactionCard(
                      inprogress: false, start: DateTime(2023, 10, 16, 9, 0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TransactionCard(
                      inprogress: false, start: DateTime(2023, 10, 16, 9, 0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TransactionCard(
                      inprogress: false, start: DateTime(2023, 10, 16, 9, 0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TransactionCard(
                      inprogress: false, start: DateTime(2023, 10, 16, 9, 0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TransactionCard(
                      inprogress: false, start: DateTime(2023, 10, 16, 9, 0)),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
