
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';

class ReassignDialog extends StatefulWidget {
  final ServiceRequestData request;

  const ReassignDialog({super.key, required this.request});

  @override
  State<ReassignDialog> createState() => _ReassignDialogState();
}

class _ReassignDialogState extends State<ReassignDialog> {
  String? _selectedNurseId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Re-assign Request'),
      content: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('nurses').where('isAvailable', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final nurses = snapshot.data!.docs;

          return DropdownButtonFormField<String>(
            value: _selectedNurseId,
            onChanged: (value) {
              setState(() {
                _selectedNurseId = value;
              });
            },
            items: nurses.map((nurse) {
              final nurseData = nurse.data() as Map<String, dynamic>?;
              final nurseName = nurseData?['name'] as String? ?? 'Unnamed Nurse';
              return DropdownMenuItem(
                value: nurse.id,
                child: Text(nurseName),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Select a new nurse'),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedNurseId == null
              ? null
              : () {
                  FirebaseFunctions.instance.httpsCallable('reassignrequest').call({
                    'requestId': widget.request.requestId,
                    'newNurseId': _selectedNurseId,
                  });
                  Navigator.of(context).pop();
                },
          child: const Text('Re-assign'),
        ),
      ],
    );
  }
}
