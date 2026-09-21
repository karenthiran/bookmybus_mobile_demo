enum SeatBlockType { permanent, dateRange }

enum SeatState { available, selectedForBlocking, permanentlyUnavailable, temporarilyUnavailable, booked }

class SeatBlock {
  SeatBlock({
    required this.id,
    required this.seatNumbers,
    required this.type,
    this.startDate,
    this.endDate,
  });

  final String id;
  final List<int> seatNumbers;
  final SeatBlockType type;
  final DateTime? startDate;
  final DateTime? endDate;
}

class SeatRelease {
  SeatRelease({
    required this.id,
    required this.seatNumbers,
    required this.startDate,
    required this.endDate,
  });

  final String id;
  final List<int> seatNumbers;
  final DateTime startDate;
  final DateTime endDate;
}
