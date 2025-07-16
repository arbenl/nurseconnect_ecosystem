import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nurseconnect_admin/dashboard/state/dashboard_state.dart';
import 'package:nurseconnect_admin/dashboard/widgets/request_column_widget.dart';
import 'package:nurseconnect_admin/dashboard/analytics_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ChangeNotifierProvider(
        create: (_) => DashboardState(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Admin Dashboard'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.dashboard), text: 'Board'),
                Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Consumer<DashboardState>(
                builder: (context, state, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: RequestColumnWidget(
                          title: 'Pending',
                          requests: state.pendingRequests,
                          color: Colors.blue[100],
                        ),
                      ),
                      Expanded(
                        child: RequestColumnWidget(
                          title: 'In Progress',
                          requests: state.inProgressRequests,
                          color: Colors.orange[100],
                        ),
                      ),
                      Expanded(
                        child: RequestColumnWidget(
                          title: 'Completed',
                          requests: state.completedRequests,
                          color: Colors.green[100],
                        ),
                      ),
                      Expanded(
                        child: RequestColumnWidget(
                          title: 'Problem',
                          requests: state.problemRequests,
                          color: Colors.red[100],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const AnalyticsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
