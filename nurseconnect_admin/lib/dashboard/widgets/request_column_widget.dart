
import 'package:flutter/material.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:nurseconnect_admin/dashboard/widgets/request_card_widget.dart';

class RequestColumnWidget extends StatelessWidget {
  final String title;
  final List<ServiceRequestData> requests;
  final Color? color;

  const RequestColumnWidget({
    super.key,
    required this.title,
    required this.requests,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCardWidget(request: requests[index], columnTitle: title);
              },
            ),
          ),
        ],
      ),
    );
  }
}
