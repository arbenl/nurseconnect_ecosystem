// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect/core/utils/app_logger.dart';

import '../../../../core/router/app_router.dart';
import '../bloc/login_bloc.dart';
import '../../../../core/dependency_injection/injection_container.dart';

class LoginScreen extends StatefulWidget {
  // Using StatefulWidget because we need to manage TextEditingControllers,
  // which have their own state and need to be disposed.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to manage the text input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // A key for managing the Form state (useful for validation later)
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Always dispose controllers when the widget is removed from the tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider makes the LoginBloc instance available to its descendants
    // We create (or rather, retrieve from GetIt) the Bloc instance here.
    return BlocProvider(
      create: (_) => sl<LoginBloc>(), // Use GetIt to provide the Bloc instance
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NurseConnect Login'),
          centerTitle: true, // Optional: center the title
        ),
        // BlocConsumer listens to state changes for side effects (listener)
        // and rebuilds the UI based on the state (builder).
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              // Hide any previous snackbars before showing a new one
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login Failed: ${state.message}'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            else if (state is LoginSuccessNurse) {
              AppLogger.log("Login Success (Nurse) state received by UI - Navigating to Nurse Home", tag: "LoginScreen");
              context.goNamed(AppRoutes.nurseHome); // Assumes 'nurseHome' route will be defined
            }
            // --- *** END SPECIFIC SUCCESS HANDLING *** ---
          },
          builder: (context, state) {
            // The builder rebuilds the UI whenever the LoginState changes.
            return Padding(
              padding: const EdgeInsets.all(24.0), // Add some padding
              child: Form( // Use a Form widget for input fields
                key: _formKey, // Associate the form key
                child: Center( // Center the column vertically
                  child: SingleChildScrollView( // Allows scrolling on small screens
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Buttons stretch
                      children: <Widget>[
                        // App Title/Logo Placeholder
                        const Icon(Icons.local_hospital, size: 60, color: Colors.deepPurple),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Login to connect with care.',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'you@example.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          // Add validator later if using _formKey for validation
                          // validator: (value) => ...
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            prefixIcon: Icon(Icons.lock_outline),
                            // TODO: Add suffix icon to toggle password visibility
                          ),
                          obscureText: true, // Hide password text
                          // Add validator later
                          // validator: (value) => ...
                        ),
                        const SizedBox(height: 30),

                        // Show loading indicator or login button based on state
                        if (state is LoginLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                        // Login Button
                          ElevatedButton(
                            onPressed: state is LoginLoading ? null : () {
                              // // Optional: Use Form key for validation
                              // if (_formKey.currentState?.validate() ?? false) { ... }

                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              // Basic check: ensure fields are not empty
                              if (email.isNotEmpty && password.isNotEmpty) {
                                // Access the bloc instance provided by BlocProvider above
                                // and add the LoginButtonPressed event.
                                context.read<LoginBloc>().add(
                                  LoginButtonPressed(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter both email and password.'),
                                    backgroundColor: Colors.orangeAccent,
                                  ),
                                );
                              }
                            },
                            child: const Text('LOGIN', style: TextStyle(fontSize: 16)),
                          ),

                        // Nurse Registration Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Are you a nurse? "),
                            TextButton(
                              onPressed: () {
                                // Use the string literal name defined in GoRoute
                                context.pushNamed('registerNurse');
                              },
                              child: const Text('Register Here'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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