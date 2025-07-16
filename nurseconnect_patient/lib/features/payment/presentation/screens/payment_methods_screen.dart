import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_patient/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:nurseconnect_patient/core/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(AppRoutes.addPaymentMethod),
          ),
        ],
      ),
      body: userId == null
          ? const Center(child: Text('Please log in to view your payment methods.'))
          : BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is PaymentLoading || state is PaymentInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PaymentMethodsLoaded) {
                  if (state.paymentMethods.isEmpty) {
                    return const Center(
                      child: Text('You have no saved payment methods.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = state.paymentMethods[index];
                      return ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text('**** **** **** ${method.last4}'),
                        subtitle: Text(method.brand),
                        trailing: method.isDefault
                            ? const Chip(label: Text('Default'))
                            : null,
                      );
                    },
                  );
                } else if (state is PaymentError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}