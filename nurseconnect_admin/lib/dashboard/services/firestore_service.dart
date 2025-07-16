import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ServiceRequestData>> streamServiceRequests() {
    return _db.collection('serviceRequests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ServiceRequestData.fromSnapshot(doc)).toList();
    });
  }
}