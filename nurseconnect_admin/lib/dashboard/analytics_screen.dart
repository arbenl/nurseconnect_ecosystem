import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Future<void> _generateCsv() async {
    final requestsSnapshot = await FirebaseFirestore.instance
        .collection('serviceRequests')
        .where('requestTimestamp', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 7)))
        .get();

    final List<List<dynamic>> rows = [];
    rows.add(['Request ID', 'Patient Name', 'Nurse Name', 'Status', 'Timestamp']);

    for (final doc in requestsSnapshot.docs) {
      final request = doc.data();
      rows.add([
        doc.id,
        request['patientName'] ?? 'N/A',
        request['assignedNurseName'] ?? 'N/A',
        request['status'] ?? 'N/A',
        (request['requestTimestamp'] as Timestamp).toDate().toIso8601String(),
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "service_requests.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _generateCsv,
            tooltip: 'Export to CSV',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('serviceRequests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final requests = snapshot.data!.docs;
          final activeRequests = requests.where((doc) => doc['status'] != 'completed' && doc['status'] != 'cancelled' && doc['status'] != 'failed').length;
          final totalCompleted = requests.where((doc) => doc['status'] == 'completed').length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Key Performance Indicators', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.local_hospital),
                  title: const Text('Active Requests'),
                  trailing: Text(activeRequests.toString(), style: Theme.of(context).textTheme.headlineMedium),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Total Completed Requests'),
                  trailing: Text(totalCompleted.toString(), style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}