// lib/features/active_service/presentation/screens/active_service_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect/features/active_service/presentation/bloc/active_service_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ActiveServiceScreen extends StatefulWidget {
  final String serviceRequestId;

  const ActiveServiceScreen({super.key, required this.serviceRequestId});

  @override
  State<ActiveServiceScreen> createState() => _ActiveServiceScreenState();
}

class _ActiveServiceScreenState extends State<ActiveServiceScreen> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActiveServiceBloc>()
        ..add(LoadActiveService(serviceRequestId: widget.serviceRequestId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Active Service'),
        ),
        body: BlocListener<ActiveServiceBloc, ActiveServiceState>(
          listener: (context, state) {
            if (state is ActiveServiceCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service completed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Do not pop here, wait for rating submission
            } else if (state is ActiveServiceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: \${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ActiveServiceCompletionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Completion Error: \${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is RatingSubmissionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rating submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(); // Go back after rating submission
            } else if (state is RatingSubmissionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rating submission failed: \${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ActiveServiceBloc, ActiveServiceState>(
            builder: (context, state) {
              if (state is ActiveServiceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActiveServiceLoaded) {
                final serviceRequest = state.serviceRequest;
                if (serviceRequest.status == ServiceRequestStatus.completed) {
                  return _buildRatingWidget(context, serviceRequest);
                } else {
                  return _buildServiceDetails(context, serviceRequest, state);
                }
              } else if (state is ActiveServiceError) {
                return Center(child: Text('Error: \${state.message}'));
              } else if (state is ActiveServiceCompleting) {
                final serviceRequest = state.serviceRequest;
                return _buildServiceDetails(context, serviceRequest, state);
              } else if (state is RatingSubmissionInProgress) {
                final serviceRequest = state.serviceRequest;
                return _buildRatingWidget(context, serviceRequest, isLoading: true);
              }
              return const Center(child: Text('Initial State'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDetails(BuildContext context, ServiceRequestData serviceRequest, ActiveServiceState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient: \${serviceRequest.patientName}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Address: \${serviceRequest.patientAddress}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Service: \${serviceRequest.serviceDetails}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: state is ActiveServiceCompleting
                  ? null
                  : () {
                      context.read<ActiveServiceBloc>().add(
                            CompleteServiceRequested(
                                serviceRequestId: widget.serviceRequestId),
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: state is ActiveServiceCompleting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Complete Service'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWidget(BuildContext context, ServiceRequestData serviceRequest, {bool isLoading = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Completed!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Text(
            'Please rate your experience:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Center(
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}