
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeedingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedUsers() async {
    if (kDebugMode) {
      final users = [
        {'name': 'Patient One', 'email': 'patient1@test.com'},
        {'name': 'Patient Two', 'email': 'patient2@test.com'},
        {'name': 'Patient Three', 'email': 'patient3@test.com'},
      ];

      for (var userData in users) {
        try {
          final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: userData['email']!,
            password: '111111',
          );

          final User? user = userCredential.user;

          if (user != null) {
            await _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'name': userData['name'],
              'email': userData['email'],
              'createdAt': FieldValue.serverTimestamp(),
              'role': 'patient',
            });
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            // User already exists, which is fine for seeding.
          } else {
            // Handle other errors if necessary.
          }
        }
      }
    }
  }
}
