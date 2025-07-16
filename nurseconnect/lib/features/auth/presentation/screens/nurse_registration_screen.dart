// lib/features/auth/presentation/screens/nurse_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';

import '../../../../core/router/app_router.dart';
import '../bloc/nurse_registration_bloc.dart';
import '../../../../core/dependency_injection/injection_container.dart';

class NurseRegistrationScreen extends StatefulWidget {
  const NurseRegistrationScreen({super.key});

  @override
  State<NurseRegistrationScreen> createState() => _NurseRegistrationScreenState();
}

class _NurseRegistrationScreenState extends State<NurseRegistrationScreen> {
  // Controllers for input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper to show snackbar messages
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // Ensure widget is still in the tree
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous ones
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide the NurseRegistrationBloc (ensure it's registered in GetIt first)
    return BlocProvider(
      // We will register NurseRegistrationBloc in GetIt later
      create: (_) => sl<NurseRegistrationBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Nurse Account'),
        ),
        // Use BlocConsumer to react to state changes and rebuild UI
        body: BlocConsumer<NurseRegistrationBloc, NurseRegistrationState>(
          listener: (context, state) {
            if (state is NurseRegistrationFailure) {
              _showSnackBar('Registration Failed: ${state.message}', isError: true);
            } else if (state is NurseRegistrationSuccess) {
              _showSnackBar('Nurse Registration Successful!');
              // Navigate back to login after successful registration
              context.goNamed(AppRoutes.login);
              AppLogger.log("Nurse Registration Success state received by UI - Navigating to Login", tag: "NurseRegistrationScreen");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Enter Your Nurse Details',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'you@example.com',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) { // Basic email validation
                            if (value == null || value.isEmpty) return 'Please enter your email';
                            if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password (min 6 chars)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter a password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done, // Indicate last field
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please confirm your password';
                            if (value != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // Loading indicator or Submit button
                        if (state is NurseRegistrationLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed: state is NurseRegistrationLoading ? null : () {
                              // Use Form key validation
                              if (_formKey.currentState?.validate() ?? false) {
                                // If validation passes, add event to Bloc
                                context.read<NurseRegistrationBloc>().add(
                                  NurseRegistrationSubmitted(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              } else {
                                _showSnackBar('Please correct the errors in the form.', isError: true);
                              }
                            },
                            child: const Text('REGISTER AS NURSE', style: TextStyle(fontSize: 16)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}