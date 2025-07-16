import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:nurseconnect_patient/features/history/presentation/bloc/bloc.dart';

class PatientServiceHistoryScreen extends StatelessWidget {
  const PatientServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Service History"),
        backgroundColor: Colors.teal,
      ),
      body: userId == null
          ? const Center(child: Text("Please log in to see your history."))
          : BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading || state is HistoryInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HistoryLoaded) {
                  if (state.history.isEmpty) {
                    return const Center(
                      child: Text("You have no service history yet."),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final entry = state.history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                entry.status == ServiceRequestStatus.completed
                                    ? Icons.medical_services
                                    : Icons.healing,
                                color: Colors.teal,
                                size: 40.0,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.serviceDetails,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      "${entry.requestTimestamp.toDate().toString()} - ${entry.assignedNurseName ?? 'N/A'}",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$N/A", // Placeholder for cost
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Chip(
                                    label: Text(
                                      entry.status.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: entry.status == ServiceRequestStatus.completed
                                        ? Colors.green
                                        : Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is HistoryError) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
