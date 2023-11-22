import 'package:client_app/Screens/Dashboard/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:client_app/Screens/Welcome/welcome_screen.dart';
import 'package:client_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDNvzdDM7tBm1hc3j0tbZPJ4o8id6wsMtQ",
      appId: "1:192421180564:android:40dd327e40f08bd06b7081",
      messagingSenderId: "192421180564",
      projectId: "capstone-tarik",
      authDomain: "capstone-tarik.firebaseapp.com",
      storageBucket: "capstone-tarik.appspot.com",
    ));
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  if (Firebase.apps.isNotEmpty) {
    print("Firebase has been initialized.");
  } else {
    print("Firebase initialization failed.");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: kPrimaryLightColor,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            )),
        home: WelcomeScreen());
  }
}
