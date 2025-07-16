
import 'package:flutter/foundation.dart';
import 'package:nurseconnect_shared/models/service_request_data.dart';
import 'package:nurseconnect_admin/dashboard/services/firestore_service.dart';

class DashboardState extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ServiceRequestData> _allRequests = [];

  List<ServiceRequestData> get pendingRequests {
    return _allRequests.where((r) {
      return [
        ServiceRequestStatus.pending,
        ServiceRequestStatus.offered,
      ].contains(r.status);
    }).toList();
  }

  List<ServiceRequestData> get inProgressRequests {
    return _allRequests.where((r) {
      return [
        ServiceRequestStatus.assigned,
        ServiceRequestStatus.nurseEnRoute,
        ServiceRequestStatus.inProgress,
      ].contains(r.status);
    }).toList();
  }

  List<ServiceRequestData> get completedRequests {
    return _allRequests.where((r) => r.status == ServiceRequestStatus.completed).toList();
  }

  List<ServiceRequestData> get problemRequests {
    return _allRequests.where((r) {
      return [
        ServiceRequestStatus.cancelled,
        ServiceRequestStatus.failed
      ].contains(r.status);
    }).toList();
  }

  DashboardState() {
    _firestoreService.streamServiceRequests().listen((requests) {
      _allRequests = requests;
      _allRequests.sort((a, b) => a.requestTimestamp.compareTo(b.requestTimestamp));
      notifyListeners();
    });
  }
}
