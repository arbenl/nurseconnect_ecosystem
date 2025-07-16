import 'package:flutter/material.dart';
import 'package:nurseconnect_shared/models/nurse_profile_data.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseDetailsScreen extends StatelessWidget {
  final NurseProfileData nurse;

  const NurseDetailsScreen({super.key, required this.nurse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nurse.name),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('serviceRequests')
            .where('assignedNurseId', isEqualTo: nurse.uid)
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