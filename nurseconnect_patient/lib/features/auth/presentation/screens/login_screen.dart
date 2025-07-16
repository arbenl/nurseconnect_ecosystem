import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added import

import '../../../../core/router/app_router.dart';
import '../bloc/login_bloc.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    if (email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    if (_rememberMe) {
      await _storage.write(key: 'email', value: _emailController.text.trim());
      await _storage.write(key: 'password', value: _passwordController.text.trim());
    } else {
      await _storage.delete(key: 'email');
      await _storage.delete(key: 'password');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Care Home'),
          centerTitle: true,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login Failed: ${state.message}'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            } else if (state is LoginSuccessPatient) {
              _saveCredentials();
              AppLogger.log("Login Success (Patient) state received by UI - Navigating to Home", tag: "LoginScreen");
              context.goNamed(AppRoutes.home);
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
                        const Icon(Icons.home, size: 60, color: Colors.teal),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome to Your Care',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to request home nursing services.',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'you@example.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.teal),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.teal),
                          ),
                          obscureText: true,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        if (state is LoginLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: state is LoginLoading ? null : () {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text.trim();

                                  if (email.isNotEmpty && password.isNotEmpty) {
                                    context.read<LoginBloc>().add(
                                      LoginButtonPressed(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                                  } else {
                                    // No async gap here, so no mounted check needed
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter both email and password.'),
                                        backgroundColor: Colors.orangeAccent,
                                      ),
                                    );
                                  }
                                },
                                child: state is LoginLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text('LOGIN', style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("New here?"),
                            TextButton(
                              onPressed: () {
                                context.pushNamed('registerPatient');
                              },
                              child: const Text('Create an Account'),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            if (email.isEmpty) {
                              if (!mounted) return; // Check mounted before using context
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your email address.'),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                              );
                              return; // Exit if email is empty
                            }

                            // Store messenger before async gap
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                              if (!mounted) return; // Check mounted after async gap
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Password reset email sent.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return; // Check mounted after async gap
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Error sending reset email: ${e.toString()}'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          child: const Text('Forgot Password?'),
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
