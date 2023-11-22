import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(
    String name,
    email,
    uid,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name, 'due': 0.0});
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = userQuerySnapshot.docs.first;
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  static Future<void> updateDueAmount(String email, double newDueAmount) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Update the document where 'email' is equal to the specified email
      await users
          .where('email', isEqualTo: email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // Update the 'amount' field with the newDueAmount
          doc.reference.update({'amount': newDueAmount});
        });
      });

      print('Due amount updated successfully.');
    } catch (e) {
      print('Error updating due amount: $e');
    }
  }
}
