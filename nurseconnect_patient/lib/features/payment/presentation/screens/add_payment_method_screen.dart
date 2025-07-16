import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_patient/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect_patient/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // This should ideally not be reached if the user navigates from a protected screen
      return Scaffold(
        appBar: AppBar(title: const Text('Add Payment Method')),
        body: const Center(child: Text('Please log in to add payment methods.')),
      );
    }

    return BlocProvider.value(
      value: sl<PaymentBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Card'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey[100],
        body: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card added successfully!'), backgroundColor: Colors.green),
              );
              context.pop(); // Go back on success
            } else if (state is PaymentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  onCreditCardWidgetChange: (CreditCardBrand brand) {},
                  bankName: 'PatientConnect Bank',
                  cardBgColor: Colors.blueGrey.shade700,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreditCardForm(
                          formKey: _formKey,
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          onCreditCardModelChange: (CreditCardModel data) {
                            setState(() {
                              cardNumber = data.cardNumber;
                              expiryDate = data.expiryDate;
                              cardHolderName = data.cardHolderName;
                              cvvCode = data.cvvCode;
                              isCvvFocused = data.isCvvFocused;
                            });
                          },
                          inputConfiguration: const InputConfiguration(
                            cardNumberDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number',
                              hintText: 'XXXX XXXX XXXX XXXX',
                            ),
                            expiryDateDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expired Date',
                              hintText: 'MM/YY',
                            ),
                            cvvCodeDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'CVV',
                              hintText: 'XXX',
                            ),
                            cardHolderDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Card Holder',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    minimumSize: const Size(double.infinity, 50),
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () => context.pop(),
                                  child: const Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BlocBuilder<PaymentBloc, PaymentState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: Colors.blueGrey.shade800,
                                      ),
                                      onPressed: state is PaymentLoading ? null : () => _onValidate(context, currentUser.uid),
                                      child: state is PaymentLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text('Add Card', style: TextStyle(fontSize: 18, color: Colors.white)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  void _onValidate(BuildContext context, String userId) {
    if (_formKey.currentState?.validate() ?? false) {
      // Extract brand and last 4 digits from the card number
      final String cardBrand = detectCCType(cardNumber);
      final String last4 = cardNumber.length >= 4 ? cardNumber.substring(cardNumber.length - 4) : '';

      context.read<PaymentBloc>().add(AddPaymentMethod(
        userId: userId,
        paymentDetails: {
          'cardType': cardBrand, // This is a more reliable way to get the type
          'last4': last4,
          'brand': cardBrand,
          'isDefault': false,
          // You would not store the full card number, expiry, or CVV in a real app.
          // This is just for the purpose of this example.
          'cardHolderName': cardHolderName,
          'expiryDate': expiryDate,
        },
      ));
    }
  }

  // Basic card type detection logic
  String detectCCType(String cardNumber) {
    if (cardNumber.startsWith(RegExp(r'(4)'))) {
      return 'Visa';
    } else if (cardNumber.startsWith(RegExp(r'(5[1-5])'))) {
      return 'Mastercard';
    } else if (cardNumber.startsWith(RegExp(r'(3[47])'))) {
      return 'American Express';
    } else if (cardNumber.startsWith(RegExp(r'(6011|65|64[4-9]|622)'))) {
      return 'Discover';
    }
    return 'Unknown';
  }
}