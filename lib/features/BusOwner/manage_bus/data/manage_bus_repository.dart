import '../../../../core/network/api_client.dart';
import '../models/manage_bus_model.dart';

/// Fetches the signed-in company's buses from the backend
/// (`GET /api/companies/buses` -> server/controllers/companyController.js
/// -> getCompanyBuses, which returns raw Bus documents).
class ManageBusRepository {
  Future<List<BusFleetModel>> fetchBuses() async {
    final json = await ApiClient.instance.get('/companies/buses');
    final list = (json as List?) ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(_mapBus)
        .toList(growable: false);
  }

  BusFleetModel _mapBus(Map<String, dynamic> bus) {
    final route = (bus['route'] as Map?) ?? const {};
    final schedule = (bus['schedule'] as Map?) ?? const {};
    final pickups = ((bus['pickups'] as List?) ?? const [])
        .whereType<Map>()
        .map((p) => PickupStop(
              city: (p['place'] ?? '').toString(),
              time: (p['time'] ?? '').toString(),
            ))
        .toList();

    return BusFleetModel(
      busName: (bus['busName'] ?? '').toString(),
      registrationNo: (bus['busNo'] ?? '').toString(),
      fromCity: (route['from'] ?? '').toString(),
      toCity: (route['to'] ?? '').toString(),
      busType: (bus['type'] ?? '').toString(),
      totalSeats: ((bus['seats'] as num?) ?? 0).toInt(),
      departure: (schedule['departure'] ?? '').toString(),
      arrival: (schedule['arrival'] ?? '').toString(),
      price: 'LKR ${((bus['price'] as num?) ?? 0).toStringAsFixed(2)}',
      status: (bus['isActive'] == false) ? BusStatus.inactive : BusStatus.active,
      approvalStatus: _mapApprovalStatus((bus['status'] ?? '').toString()),
      frequency: (bus['frequency'] ?? 'Daily').toString(),
      seatLayout: (bus['seatLayoutType'] ?? '').toString(),
      amenities: ((bus['amenities'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      pickups: pickups,
      imageUrl: (bus['imageUrl'] as String?),
    );
  }

  BusApprovalStatus _mapApprovalStatus(String backendStatus) {
    switch (backendStatus) {
      case 'approved':
        return BusApprovalStatus.approved;
      case 'pending':
        return BusApprovalStatus.pending;
      case 'suspended':
      case 'rejected':
      default:
        return BusApprovalStatus.rejected;
    }
  }
}
