
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

/// A welcoming and informative landing screen for new users.
///
/// This screen provides a clear overview of the app's value proposition
/// before a user commits to registering or logging in. It features a prominent
/// illustration placeholder, key feature highlights, and clear calls-to-action.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to make layout responsive to screen size
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          // Consistent padding around the screen content
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // 1. Illustration Placeholder
              // A container to hold a friendly healthcare-related illustration.
              // Replace this with an Image.asset('assets/images/your_illustration.png')
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Illustration Placeholder',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 2. Headline
              // A prominent, welcoming headline to grab the user's attention.
              const Text(
                'Quality Care, Right at Your Doorstep.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748), // A deep, professional blue-gray
                ),
              ),
              const SizedBox(height: 16),

              // 3. Sub-headline
              // A reassuring message that elaborates on the headline.
              const Text(
                'Connect with trusted and qualified nursing professionals whenever you need them.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),

              // 4. Feature Highlights
              // A section to showcase the key benefits of the app.
              _buildFeatureHighlight(
                icon: Icons.local_hospital,
                text: 'On-Demand Service',
              ),
              const SizedBox(height: 16),
              _buildFeatureHighlight(
                icon: Icons.verified_user,
                text: 'Verified Professionals',
              ),
              const SizedBox(height: 16),
              _buildFeatureHighlight(
                icon: Icons.location_on,
                text: 'Real-Time Tracking',
              ),

              const Spacer(),

              // 5. Call-to-Action Buttons
              // Buttons for primary (register) and secondary (login) actions.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.registration);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3182CE), // A strong, trustworthy blue
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.login);
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF3182CE),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Some padding at the bottom
            ],
          ),
        ),
      ),
    );
  }

  /// A helper widget to create a consistent layout for feature highlights.
  ///
  /// Each feature consists of an Icon and a descriptive Text in a Row.
  Widget _buildFeatureHighlight({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: const Color(0xFF3182CE),
          size: 24.0,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}
