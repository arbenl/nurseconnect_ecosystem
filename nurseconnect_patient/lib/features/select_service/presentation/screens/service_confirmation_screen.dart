import 'package:flutter/material.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_patient/core/router/app_router.dart';
import 'package:nurseconnect_patient/features/home/presentation/bloc/home_bloc_barrel.dart';

class ServiceConfirmationScreen extends StatefulWidget {
  final NursingService selectedService;

  const ServiceConfirmationScreen({super.key, required this.selectedService});

  @override
  State<ServiceConfirmationScreen> createState() => _ServiceConfirmationScreenState();
}

class _ServiceConfirmationScreenState extends State<ServiceConfirmationScreen> {
  PaymentMethod? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${widget.selectedService.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${widget.selectedService.description}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.selectedService.price != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Price: \$${widget.selectedService.price!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            const SizedBox(height: 30),
            // Payment Method Selection
            ListTile(
              title: const Text('Payment Method'),
              subtitle: _selectedPaymentMethod == null
                  ? const Text('Select a payment method')
                  : Text('${_selectedPaymentMethod!.cardType} **** ${_selectedPaymentMethod!.last4}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final result = await context.pushNamed(AppRoutes.selectPaymentMethod); // Navigate to payment methods screen
                if (result != null && result is PaymentMethod) {
                  setState(() {
                    _selectedPaymentMethod = result;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_selectedPaymentMethod == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a payment method.')),
                  );
                  return;
                }

                // Get current location before dispatching the event
                bool serviceEnabled;
                LocationPermission permission;

                try {
                  serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    throw Exception('Location services are disabled.');
                  }

                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      throw Exception('Location permissions are denied.');
                    }
                  }

                  if (permission == LocationPermission.deniedForever) {
                    throw Exception('Location permissions are permanently denied.');
                  }

                  Position position = await Geolocator.getCurrentPosition(
                      locationSettings: const LocationSettings(
                        accuracy: LocationAccuracy.high,
                        distanceFilter: 0,
                      ));

                  // Dispatch the event to HomeBloc
                  if (context.mounted) {
                    context.read<HomeBloc>().add(SubmitServiceRequest(
                      service: widget.selectedService,
                      currentPosition: position,
                      paymentMethodId: _selectedPaymentMethod!.id, // Pass selected payment method ID
                    ));
                    // Navigate back to home/tracking screen after dispatching
                    context.goNamed(AppRoutes.home);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error getting location: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Confirm and Request Service'),
            ),
          ],
        ),
      ),
    );
  }
}
