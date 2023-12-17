import 'package:client_app/Screens/Dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client_app/components/user.dart';
import 'package:client_app/firebase/firebasefunction.dart';

class AuthServices {
  static signupUser(
      String email,
      String password,
      String name,
      String selectedRole,
      String id,
      String phone,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addNewUser(email, name, 0.0, selectedRole, id, phone);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } catch (e) {
      print(e);
      String error = extractErrorMessage(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  static extractErrorMessage(String error) {
    // Find the index of the closing square bracket
    int bracketIndex = error.indexOf(']');

    // If the closing square bracket is found, extract the substring after it
    // Otherwise, return the original error string
    return bracketIndex != -1
        ? error.substring(bracketIndex + 1).trim()
        : error;
  }

  static signinUser(String email, String password, BuildContext context) async {
    if (!email.contains('@') && !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Email id format'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      final _auth = await FirebaseAuth.instance;
      print(email);
      print(password);
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user);

      if (user != null) {
        DocumentSnapshot? userDetails = await fetchDocumentByEmail(email);
        String name = '';
        double dueAmount = 0.0;
        if (userDetails != null) {
          name = userDetails['name'];
          dueAmount = userDetails['amount'].toDouble();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DashboardPage(
                  user:
                      UserData(email: email, name: name, dueAmount: dueAmount),
                );
              },
            ),
          );
        } else {
          print('User details not found.');
        } // userData['due'];
      } else
        print('no user');
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Wrong Credentials'),
        duration: Duration(seconds: 2),
      ));
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

  static Future<void> addNewUser(String email, String name, double amount,
      String selectedRole, String id, String phone) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.add({
        'email': email,
        'name': name,
        'amount': amount,
        'role': selectedRole,
        'id': id,
        'phone': phone
      });

      print('New user added successfully.');
    } catch (e) {
      print('Error adding new user: $e');
    }
  }
}
