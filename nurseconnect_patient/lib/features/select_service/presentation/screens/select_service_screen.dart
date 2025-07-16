import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_patient/core/dependency_injection/injection_container.dart';
import 'package:nurseconnect_patient/core/router/app_router.dart';
import 'package:nurseconnect_patient/features/select_service/presentation/bloc/select_service_bloc.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SelectServiceBloc>()..add(LoadServices()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a Service'),
        ),
        body: BlocConsumer<SelectServiceBloc, SelectServiceState>(
          listener: (context, state) {
            if (state is ServiceSelectionSuccess) {
              // Navigate to confirmation screen, passing the selected service
              context.goNamed(AppRoutes.serviceConfirmation, extra: state.selectedService);
            }
          },
          builder: (context, state) {
            if (state is SelectServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SelectServiceLoaded) {
              return ListView.builder(
                itemCount: state.services.length,
                itemBuilder: (context, index) {
                  final service = state.services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(service.description),
                      trailing: service.price != null
                          ? Text('\$${service.price!.toStringAsFixed(2)}')
                          : null,
                      onTap: () {
                        context.read<SelectServiceBloc>().add(ServiceSelected(service: service));
                      },
                    ),
                  );
                },
              );
            } else if (state is SelectServiceError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No services available.'));
          },
        ),
      ),
    );
  }
}
