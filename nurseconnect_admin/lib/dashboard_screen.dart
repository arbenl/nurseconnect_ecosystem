import 'package:nurseconnect_shared/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NurseConnect Admin Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KanbanColumnWidget(
              title: 'Pending',
              query: FirebaseFirestore.instance
                  .collection('serviceRequests')
                  .where('status', isEqualTo: ServiceRequestStatus.pending.name),
            ),
            KanbanColumnWidget(
              title: 'In Progress',
              query: FirebaseFirestore.instance
                  .collection('serviceRequests')
                  .where('status', isEqualTo: ServiceRequestStatus.assigned.name),
            ),
            KanbanColumnWidget(
              title: 'Arrived',
              query: FirebaseFirestore.instance
                  .collection('serviceRequests')
                  .where('status', isEqualTo: ServiceRequestStatus.arrived.name),
            ),
            KanbanColumnWidget(
              title: 'Completed',
              query: FirebaseFirestore.instance
                  .collection('serviceRequests')
                  .where('status', isEqualTo: ServiceRequestStatus.completed.name),
            ),
          ],
        ),
      ),
    );
  }
}
