import 'package:flutter/material.dart';
import 'package:nurseconnect_shared/models/user_data.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsScreen extends StatelessWidget {
  final UserData patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceRequests')
            .where('patientId', isEqualTo: patient.uid)
            .orderBy('requestTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No service history found.'));
          }

          final requests = snapshot.data!.docs
              .map((doc) => ServiceRequestData.fromSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text(request.serviceDetails),
                subtitle: Text('Status: ${request.status.name}'),
                trailing: Text(request.requestTimestamp.toDate().toString()),
              );
            },
          );
        },
      ),
    );
  }
}