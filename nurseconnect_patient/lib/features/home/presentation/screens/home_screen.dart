import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.pushNamed(AppRoutes.patientProfile),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWelcomeHeader(context, "John Doe"), // Placeholder name
          const SizedBox(height: 24),
          _buildActionCard(
            context,
            icon: Icons.add_circle_outline,
            title: 'Request a New Service',
            subtitle: 'Get professional nursing care when you need it.',
            color: Colors.blue,
            onTap: () => context.pushNamed(AppRoutes.selectService),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context,
            icon: Icons.history,
            title: 'View Service History',
            subtitle: 'Check the status and details of past services.',
            color: Colors.purple,
            onTap: () => context.pushNamed(AppRoutes.patientServiceHistory),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context,
            icon: Icons.payment_outlined,
            title: 'Manage Payments',
            subtitle: 'View and update your payment methods.',
            color: Colors.orange,
            onTap: () => context.pushNamed(AppRoutes.paymentMethods),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
