import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  late bool _marketingConsent;
  late bool _pushNotificationsEnabled;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _marketingConsent = state.patientProfile.marketingConsent ?? false;
      _pushNotificationsEnabled = state.patientProfile.pushNotificationsEnabled ?? false;
    } else {
      _marketingConsent = false;
      _pushNotificationsEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy settings updated successfully!')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: const Text('Marketing Consent'),
                subtitle: const Text('Receive promotional emails and offers'),
                trailing: Switch(
                  value: _marketingConsent,
                  onChanged: (value) {
                    setState(() {
                      _marketingConsent = value;
                    });
                    // Dispatch BLoC event to update preference
                    final currentState = context.read<ProfileBloc>().state;
                    if (currentState is ProfileLoaded) {
                      final updatedUser = currentState.patientProfile.copyWith(
                        marketingConsent: value,
                      );
                      context.read<ProfileBloc>().add(ProfileUpdateSubmitted(userData: updatedUser));
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive important app notifications'),
                trailing: Switch(
                  value: _pushNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _pushNotificationsEnabled = value;
                    });
                    // Dispatch BLoC event to update preference
                    final currentState = context.read<ProfileBloc>().state;
                    if (currentState is ProfileLoaded) {
                      final updatedUser = currentState.patientProfile.copyWith(
                        pushNotificationsEnabled: value,
                      );
                      context.read<ProfileBloc>().add(ProfileUpdateSubmitted(userData: updatedUser));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
