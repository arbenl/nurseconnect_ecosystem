import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect_patient/core/dependency_injection/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc_barrel.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Please log in to view your profile.')),
      );
    }

    return BlocProvider(
      create: (context) => sl<ProfileBloc>()
        ..add(LoadPatientProfile(patientId: currentUser.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final patientProfile = state.patientProfile;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${patientProfile.name}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Email: ${patientProfile.email}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement edit profile functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit Profile functionality coming soon!')),
                          );
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Initial State'));
          },
        ),
      ),
    );
  }
}
