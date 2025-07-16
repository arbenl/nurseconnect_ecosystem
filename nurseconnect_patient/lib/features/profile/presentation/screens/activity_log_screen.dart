import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';
import 'package:intl/intl.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final activityLog = state.patientProfile.activityLog;

            if (activityLog == null || activityLog.isEmpty) {
              return const Center(child: Text('No activity recorded.'));
            }

            return ListView.builder(
              itemCount: activityLog.length,
              itemBuilder: (context, index) {
                final entry = activityLog[index];
                final timestamp = entry['timestamp'] as String?;
                final action = entry['action'] as String?;

                String formattedTimestamp = timestamp != null
                    ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(timestamp))
                    : 'N/A';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(action ?? 'Unknown Action'),
                    subtitle: Text(formattedTimestamp),
                  ),
                );
              },
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
