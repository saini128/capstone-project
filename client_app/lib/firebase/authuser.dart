import 'package:client_app/Screens/Dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_app/components/user.dart';
import 'package:client_app/firebase/firebasefunction.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addNewUser(email, name, 0.0);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } catch (e) {
      print(e);
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      print(email);
      print(password);
      final _auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password); // Map<String, dynamic>? userData =
      //     await FirestoreServices.getUserByEmail(email);
      User? user = _auth.user;
      print(user);

      if (user != null) {
        DocumentSnapshot? userDetails = await fetchDocumentByEmail(email);
        String name = '';
        double dueAmount = 0.0;
        if (userDetails != null) {
          name = userDetails['name'];
          dueAmount = userDetails['amount'].toDouble();
          // ... (rest of the code)
        } else {
          print('User details not found.');
        } // userData['due'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DashboardPage(
                user: UserData(email: email, name: name, dueAmount: dueAmount),
              );
            },
          ),
        );
      } else
        print('no user');
    } catch (e) {
      print(e);
    }
  }

  static Future<DocumentSnapshot?> fetchDocumentByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first matching document
        return querySnapshot.docs[0];
      } else {
        // No matching documents
        return null;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }

  static Future<void> addNewUser(
      String email, String name, double amount) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Add a new document with auto-generated ID
      await users.add({
        'email': email,
        'name': name,
        'amount': amount,
      });

      print('New user added successfully.');
    } catch (e) {
      print('Error adding new user: $e');
    }
  }
}
