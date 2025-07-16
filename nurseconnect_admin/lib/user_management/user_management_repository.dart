import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchAllNurses() async {
    final snapshot = await _firestore.collection('nurses').get();
    return snapshot.docs;
  }
}
