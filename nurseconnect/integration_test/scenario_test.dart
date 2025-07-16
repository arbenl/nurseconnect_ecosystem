import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Service Request Scenario Test', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth auth;

    setUpAll(() async {
      // Initialize Firebase for tests
      await Firebase.initializeApp();

      // Connect to Firebase Emulators
      firestore = FirebaseFirestore.instance;
      auth = FirebaseAuth.instance;

      firestore.useFirestoreEmulator('10.0.2.2', 8081);
      auth.useAuthEmulator('10.0.2.2', 9098);

      // Ensure no user is logged in from previous tests
      await auth.signOut();

      // Clear Firestore data for a clean test run (optional, but good practice)
      // This requires the Firebase CLI to be running with the emulators
      // firebase emulators:start --only firestore
      // Then, you can hit the clear endpoint:
      // await firestore.collection('serviceRequests').get().then((snapshot) {
      //   for (DocumentSnapshot doc in snapshot.docs) { doc.reference.delete(); }
      // });
      debugPrint('Firestore and Auth emulators initialized.');
    });

    test('5 patients create requests, 4 get assigned, 1 remains pending', () async {
      // Ensure there are at least 4 nurses available in the emulator
      // (This test assumes the seeding script has been run and nurses are available)

      final List<String> patientUids = [];
      final List<String> requestIds = [];

      // 1. Create 5 dummy patient users and their service requests
      debugPrint('Creating 5 patient users and their service requests...');
      for (int i = 0; i < 5; i++) {
        final patientEmail = 'testpatient${DateTime.now().microsecondsSinceEpoch + i}@example.com';
        final patientPassword = 'password123';
        final patientName = 'Test Patient $i';

        // Create user in Auth
        final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: patientEmail,
          password: patientPassword,
        );
        final String patientUid = userCredential.user!.uid;
        patientUids.add(patientUid);

        // Create user profile in Firestore
        await firestore.collection('users').doc(patientUid).set({
          'uid': patientUid,
          'name': patientName,
          'email': patientEmail,
          'role': 'patient',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Create service request
        final newRequestRef = firestore.collection('serviceRequests').doc();
        final serviceRequest = ServiceRequestData(
          requestId: newRequestRef.id,
          patientId: patientUid,
          patientName: patientName,
          patientLocation: const GeoPoint(34.052235, -118.243683), // Los Angeles
          requestTimestamp: Timestamp.now(),
          status: ServiceRequestStatus.pending,
          serviceDetails: 'Basic check-up',
        );
        await newRequestRef.set(serviceRequest.toJson());
        requestIds.add(newRequestRef.id);
        debugPrint('Created request ${newRequestRef.id} for patient $patientUid');
      }

      // 3. Wait for 5 seconds to allow Cloud Functions to process
      debugPrint('Waiting for Cloud Functions to process requests via HTTP trigger...');
      final url = Uri.parse('http://10.0.2.2:5001/nurse-642a7/us-central1/requestReoffer');
      final response = await http.post(url);

      expect(response.statusCode, 200, reason: 'Expected 200 OK from Cloud Function');
      debugPrint('Cloud Function triggered successfully. Response: ${response.body}');

      // 4. Query Firestore to verify the outcome
      debugPrint('Verifying outcomes...');
      final assignedRequests = <ServiceRequestData>[];
      final pendingRequests = <ServiceRequestData>[];

      for (final requestId in requestIds) {
        final doc = await firestore.collection('serviceRequests').doc(requestId).get();
        final requestData = ServiceRequestData.fromFirestore(doc);

        if (requestData.assignedNurseId != null && requestData.status != ServiceRequestStatus.pending) {
          assignedRequests.add(requestData);
        } else if (requestData.status == ServiceRequestStatus.pending) {
          pendingRequests.add(requestData);
        }
      }

      debugPrint('Assigned requests count: ${assignedRequests.length}');
      debugPrint('Pending requests count: ${pendingRequests.length}');

      // Assert that exactly 4 of the service requests have been assigned a unique nurse
      expect(assignedRequests.length, 4, reason: 'Expected 4 requests to be assigned.');

      // Verify unique nurses (optional, but good for robustness)
      final assignedNurseIds = assignedRequests.map((r) => r.assignedNurseId).toSet();
      expect(assignedNurseIds.length, 4, reason: 'Expected 4 unique nurses to be assigned.');

      // Assert that 1 request is still pending
      expect(pendingRequests.length, 1, reason: 'Expected 1 request to remain pending.');

      debugPrint('Test completed successfully.');
    });
  });
}
