import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:nurseconnect_admin/dashboard/widgets/request_card_widget.dart';

class KanbanColumnWidget extends StatelessWidget {
  final String title;
  final Query<Map<String, dynamic>> query;

  const KanbanColumnWidget({
    super.key,
    required this.title,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width for each column
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$title (${0})', // Placeholder for count
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests'));
                }

                final requests = snapshot.data!.docs
                    .map((doc) => ServiceRequestData.fromSnapshot(doc))
                    .toList();

                // Update the count in the title
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // This is a bit of a hack to update the title with the count
                  // A more robust solution would involve a ChangeNotifierProvider
                  // or similar state management for the column title.
                  // For now, we'll just rebuild the widget.
                  // This will be handled by the parent DashboardScreen's StreamBuilder
                  // if we pass the count up, or by making the title a stateful widget.
                });

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return RequestCardWidget(
                      request: requests[index],
                      columnTitle: title,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
