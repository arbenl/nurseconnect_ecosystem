
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Care"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ValuePropositionSection(),
            const SizedBox(height: 48),
            _buildSectionTitle(context, "How It Works"),
            const SizedBox(height: 24),
            const _HowItWorksSection(),
            const SizedBox(height: 48),
            _buildSectionTitle(context, "Featured Services"),
            const SizedBox(height: 16),
            const _FeaturedServicesSection(),
            const SizedBox(height: 48),
            _buildSectionTitle(context, "What Our Patients Say"),
            const SizedBox(height: 24),
            const _PatientTestimonialsSection(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Padding _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ValuePropositionSection extends StatelessWidget {
  const _ValuePropositionSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Quality Care, Delivered to Your Door',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal.shade800),
          ),
          const SizedBox(height: 16),
          Text(
            'Professional and compassionate nursing services, right where you are most comfortable.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _HowItWorksStep(
            icon: Icons.phone_android,
            label: '1. Request Care',
          ),
          _HowItWorksStep(
            icon: Icons.person_search,
            label: '2. Get Matched',
          ),
          _HowItWorksStep(
            icon: Icons.local_hospital,
            label: '3. Receive Care',
          ),
        ],
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HowItWorksStep({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Colors.teal),
        const SizedBox(height: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeaturedServicesSection extends StatelessWidget {
  const _FeaturedServicesSection();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> services = [
      {'name': 'Wound Care', 'description': 'Expert dressing and management.'},
      {'name': 'IV Therapy', 'description': 'Administered at your home.'},
      {'name': 'Post-Op Care', 'description': 'Support for your recovery.'},
      {'name': 'Elderly Care', 'description': 'Compassionate daily assistance.'},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(right: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service['name']!,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(service['description']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PatientTestimonialsSection extends StatelessWidget {
  const _PatientTestimonialsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TestimonialCard(
          quote:
              '"The care was exceptional. The nurse was professional and made me feel at ease throughout the entire process."',
          name: 'Jane D., Patient',
        ),
        SizedBox(height: 16),
        _TestimonialCard(
          quote:
              '"Booking a service was incredibly easy and convenient. A lifesaver for our family."',
          name: 'John S., Family Member',
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String name;

  const _TestimonialCard({required this.quote, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: Colors.teal.withAlpha((0.1 * 255).round()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.teal.withAlpha((0.2 * 255).round())),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '- $name',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
