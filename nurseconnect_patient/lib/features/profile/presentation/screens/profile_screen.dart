import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurseconnect_patient/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';
import 'package:nurseconnect_patient/core/router/app_router.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserData userData) {
    _nameController.text = userData.name;
    _phoneController.text = userData.phoneNumber ?? '';
    _addressController.text = userData.address ?? '';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!mounted) return;
      context.read<ProfileBloc>().add(UploadProfileImage(imagePath: image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadPatientProfile(patientId: currentUser!.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
          actions: [
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () => setState(() => _isEditing = false),
              ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _initializeControllers(state.patientProfile);
              if (state is! ProfileLoading) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
                setState(() => _isEditing = false);
              }
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
              );
            } else if (state is ProfileSignOutSuccess) {
              context.goNamed(AppRoutes.login);
            }
          },
          builder: (context, state) {
            if (state is ProfileInitial || state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              return _isEditing
                  ? _buildEditView(context, state.patientProfile)
                  : _buildReadOnlyView(context, state.patientProfile);
            }
            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyView(BuildContext context, UserData userData) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Call image picker on tap
                child: Semantics(
                  label: 'Profile picture',
                  button: true,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userData.profilePictureUrl != null
                        ? NetworkImage(userData.profilePictureUrl!)
                        : null,
                    child: userData.profilePictureUrl == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'User name: ${userData.name}',
                child: Text(userData.name, style: Theme.of(context).textTheme.headlineSmall),
              ),
              const SizedBox(height: 8),
              Semantics(
                label: 'User email: ${userData.email}',
                child: Text(userData.email, style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, semanticLabel: 'Edit profile icon'),
                title: const Text('Edit Profile'),
                onTap: () => setState(() => _isEditing = true),
              ),
              ListTile(
                leading: const Icon(Icons.history, semanticLabel: 'Service history icon'),
                title: const Text('Service History'),
                onTap: () => context.pushNamed('profileServiceHistory'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, semanticLabel: 'Privacy settings icon'),
                title: const Text('Privacy Settings'),
                onTap: () => context.pushNamed('privacySettings'),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6, semanticLabel: 'Theme mode icon'),
                title: const Text('Theme Mode'),
                trailing: DropdownButton<String>(
                  value: userData.themeMode ?? 'system',
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // Dispatch BLoC event to change theme mode
                      // We'll define this event in the next step
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Theme mode change logic coming soon! Value: $newValue')),
                      );
                    }
                  },
                  items: <String>['light', 'dark', 'system']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize()),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt, semanticLabel: 'Activity log icon'),
                title: const Text('Activity Log'),
                onTap: () => context.pushNamed('activityLog'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(SignOutButtonPressed());
            },
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditView(BuildContext context, UserData userData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedUser = userData.copyWith(
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                    address: _addressController.text,
                  );
                  context.read<ProfileBloc>().add(ProfileUpdateSubmitted(userData: updatedUser));
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}