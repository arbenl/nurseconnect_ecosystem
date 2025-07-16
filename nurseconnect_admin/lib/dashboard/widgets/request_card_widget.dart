import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:nurseconnect_admin/dashboard/details/patient_details_screen.dart';
import 'package:nurseconnect_admin/dashboard/widgets/reassign_dialog.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:intl/intl.dart';
import 'package:nurseconnect_shared/models/user_data.dart';

class RequestCardWidget extends StatelessWidget {
  final ServiceRequestData request;
  final String columnTitle;

  const RequestCardWidget({super.key, required this.request, required this.columnTitle});

  @override
  Widget build(BuildContext context) {
    final Color cardColor = Colors.white;
    final Color textColor = Colors.black87;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      color: cardColor,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                final patientData = UserData(uid: request.patientId, name: request.patientName, email: '', role: 'patient');
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => PatientDetailsScreen(patient: patientData)));
              },
              child: Text(
                'Patient: ${request.patientName}',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: ${request.status.name}',
              style: TextStyle(color: textColor),
            ),
            if (columnTitle == 'Pending') ...[
              Text(
                'Requested at: ${DateFormat.yMd().add_jm().format(request.requestTimestamp.toDate())}',
                style: TextStyle(color: textColor),
              ),
              Text(
                'Location: ${request.patientLocation.latitude}, ${request.patientLocation.longitude}',
                style: TextStyle(color: textColor),
              ),
            ] else if (columnTitle == 'In Progress') ...[
              if (request.assignedNurseName != null)
                Text(
                  'Nurse Assigned: ${request.assignedNurseName}',
                  style: TextStyle(color: textColor),
                ),
              if (request.etaMinutes != null)
                Text(
                  'ETA: ${request.etaMinutes} minutes',
                  style: TextStyle(color: textColor),
                ),
            ] else if (columnTitle == 'Arrived') ...[
              if (request.assignedNurseName != null)
                Text(
                  'Nurse: ${request.assignedNurseName}',
                  style: TextStyle(color: textColor),
                ),
            ] else if (columnTitle == 'Completed') ...[
              if (request.assignedNurseName != null)
                Text(
                  'Nurse: ${request.assignedNurseName}',
                  style: TextStyle(color: textColor),
                ),
              if (request.completionNotes != null)
                Text(
                  'Notes: ${request.completionNotes}',
                  style: TextStyle(color: textColor),
                ),
              Text(
                'Completed at: ${DateFormat.yMd().add_jm().format(request.completedAt?.toDate() ?? DateTime.now())}',
                style: TextStyle(color: textColor),
              ),
            ],
            // Action buttons (Cancel, Re-assign) - only for In Progress column
            if (columnTitle == 'In Progress')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      FirebaseFunctions.instance.httpsCallable('cancelrequest').call({
                        'requestId': request.requestId,
                      });
                    },
                    child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ReassignDialog(request: request),
                      );
                    },
                    child: const Text("Re-assign"),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
