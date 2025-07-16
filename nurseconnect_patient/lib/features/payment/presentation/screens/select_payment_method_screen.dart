import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_patient/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect_patient/features/payment/presentation/bloc/payment_bloc.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Payment Method')),
        body: const Center(child: Text('Please log in to select a payment method.')),
      );
    }

    return BlocProvider.value(
      value: sl<PaymentBloc>()..add(LoadPaymentMethods(userId: currentUser.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Payment Method'),
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PaymentMethodsLoaded) {
              if (state.paymentMethods.isEmpty) {
                return const Center(child: Text('No payment methods found. Please add one.'));
              }
              return ListView.builder(
                itemCount: state.paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = state.paymentMethods[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(method.cardType == 'Visa' ? Icons.payment : Icons.credit_card),
                      title: Text('${method.brand} **** ${method.last4}'),
                      subtitle: Text(method.cardType),
                      trailing: method.isDefault
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        context.pop(method); // Return selected method
                      },
                    ),
                  );
                },
              );
            } else if (state is PaymentError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Initial State'));
          },
        ),
      ),
    );
  }
}