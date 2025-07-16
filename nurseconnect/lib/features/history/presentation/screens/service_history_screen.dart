import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect/features/history/presentation/bloc/history_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Service History')),
        body: const Center(child: Text('Please log in to view service history.')),
      );
    }

    return BlocProvider(
      create: (context) => sl<HistoryBloc>()
        ..add(LoadServiceHistory(nurseId: currentUser.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service History'),
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              if (state.serviceRequests.isEmpty) {
                return const Center(child: Text('No completed services found.'));
              }
              return ListView.builder(
                itemCount: state.serviceRequests.length,
                itemBuilder: (context, index) {
                  final serviceRequest = state.serviceRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service: ${serviceRequest.serviceDetails}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Patient: ${serviceRequest.patientName}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${serviceRequest.completedAt != null ? DateFormat('MMM dd, yyyy - hh:mm a').format(serviceRequest.completedAt!.toDate()) : 'N/A'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // Add more details as needed
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is HistoryError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Initial State'));
          },
        ),
      ),
    );
  }
}
