class PickupStop {
  const PickupStop({required this.city, required this.time, this.landmark});
  final String city;
  final String time;
  final String? landmark;
}

class BusFleetModel {
  const BusFleetModel({
    required this.busName,
    required this.registrationNo,
    required this.fromCity,
    required this.toCity,
    required this.busType,
    required this.totalSeats,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.status,
    required this.approvalStatus,
    this.frequency = 'Daily',
    this.seatLayout = '',
    this.amenities = const [],
    this.pickups = const [],
    this.imageUrl,
  });

  final String busName;
  final String registrationNo;
  final String fromCity;
  final String toCity;
  final String busType;
  final int totalSeats;
  final String departure;
  final String arrival;
  final String price;
  final BusStatus status;
  final BusApprovalStatus approvalStatus;
  final String frequency;
  final String seatLayout;
  final List<String> amenities;
  final List<PickupStop> pickups;
  final String? imageUrl;
}

enum BusStatus { active, inactive, maintenance }
enum BusApprovalStatus { approved, pending, rejected }
