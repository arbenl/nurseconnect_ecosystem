// lib/features/home/presentation/screens/nurse_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';          // Import Bloc
import 'package:go_router/go_router.dart';                  // For navigation
import '../../../../core/router/app_router.dart';           // For route names
import '../../../../core/dependency_injection/injection_container.dart'; // GetIt
import '../bloc/nurse_home_bloc.dart';                     // Bloc & events/states
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import '../../../../core/utils/app_logger.dart';

class NurseHomeScreen extends StatelessWidget {
  const NurseHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NurseHomeBloc>()..add(LoadNurseData()),
      child: Scaffold(
        appBar: _buildAppBar(context), // Refactored AppBar
        body: BlocConsumer<NurseHomeBloc, NurseHomeState>(
          listener: (context, state) {
            if (state is NurseHomeError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is NurseHomeOfferActionError) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Offer Action Failed: ${state.message}'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is NurseHomeLoaded && state.nurseData == null) {
              // Handle case where nurse data becomes null after loading (e.g., logout)
              context.goNamed(AppRoutes.login);
            }
          },
          builder: (context, state) {
            if (state is NurseHomeLoading && state.nurseData == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NurseHomeError && state.nurseData == null) {
              return Center(child: Text('Error loading profile: ${state.message}'));
            }
            if (state.nurseData != null) {
              final nurse = state.nurseData!;
              final offers = state.activeOffers;
              final isLoadingUpdate = state is NurseHomeLoading || state is NurseHomeLocationUpdating;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNurseInfoSection(context, nurse, isLoadingUpdate), // Refactored Nurse Info
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    _buildActiveOffersSection(context, offers, state), // Refactored Active Offers
                  ],
                ),
              );
            }
            return const Center(child: Text('Initializing...'));
          },
        ),
      ),
    );
  }

  // --- Refactored Widgets/Methods ---

  // Extracted AppBar into a separate method
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Nurse Dashboard'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
          onPressed: () {
            context.goNamed(AppRoutes.nurseProfile);
          },
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'Service History',
          onPressed: () {
            context.goNamed(AppRoutes.serviceHistory);
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            AppLogger.log("Logout requested.", tag: "NurseHomeScreen");
            context.read<NurseHomeBloc>().add(LogoutRequested());
          },
        ),
      ],
    );
  }

  // Extracted Nurse Info & Availability section
  Widget _buildNurseInfoSection(BuildContext context, NurseProfileData nurse, bool isLoadingUpdate) {
    return Column(
      children: [
        Text(
          'Welcome, ${nurse.name}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(nurse.email),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Available:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 10),
            Switch(
              value: nurse.isAvailable,
              activeColor: Colors.teal,
              onChanged: isLoadingUpdate ? null : (newValue) {
                context.read<NurseHomeBloc>().add(
                  ToggleAvailabilityRequested(desiredAvailability: newValue),
                );
              },
            ),
            if (isLoadingUpdate)
              const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        Text(
          nurse.isAvailable ? 'You will receive offers' : 'You are offline',
          style: TextStyle(
            color: nurse.isAvailable ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  // Extracted Active Offers section
  Widget _buildActiveOffersSection(BuildContext context, List<ServiceRequestData> offers, NurseHomeState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Offers (${offers.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: offers.isEmpty
                ? const Center(child: Text('No active offers.'))
                : ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      final isProcessingThisOffer = (state is NurseHomeOfferActionLoading && state.processingRequestId == offer.requestId);
                      return _buildOfferCard(context, offer, isProcessingThisOffer); // Refactored Offer Card
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Extracted individual Offer Card
  Widget _buildOfferCard(BuildContext context, ServiceRequestData offer, bool isProcessing) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text('New Request: ${offer.serviceDetails}'),
        subtitle: Text('Patient: ${offer.patientName}\nStatus: ${offer.status.name}'),
        trailing: isProcessing
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<NurseHomeBloc>().add(OfferAccepted(requestId: offer.requestId));
                    },
                    child: const Text('ACCEPT'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<NurseHomeBloc>().add(OfferRejected(requestId: offer.requestId));
                    },
                    child: const Text('REJECT'),
                  ),
                ],
              ),
      ),
    );
  }
}