class CallBookingModel {
  DateTime? travelDate;
  CallBusTripModel? selectedTrip;
  List<int> selectedSeats;
  Map<int, String> seatGenders;
  String passengerName;
  String passengerPhone;
  String passengerNic;

  String passengerEmail;
  String pickupPoint;
  String dropPoint;
  String passengerNotes;
  CallBookingModel({
    this.travelDate,
    this.selectedTrip,
    this.selectedSeats = const [],
    this.seatGenders = const {},
    this.passengerName = '',
    this.passengerPhone = '',
    this.passengerNic = '',
    this.passengerEmail = '',
    this.pickupPoint = '',
    this.dropPoint = '',
    this.passengerNotes = '',
  });
}

class CallBusTripModel {
  final String busName;
  final String busNumber;
  final String departureTime;
  final String from;
  final String to;
  final double pricePerSeat;
  final int seatsLeft;
  final List<String> pickupPoints;
  final List<String> dropPoints;

  const CallBusTripModel({
    required this.busName,
    required this.busNumber,
    required this.departureTime,
    required this.from,
    required this.to,
    required this.pricePerSeat,
    required this.seatsLeft,
    this.pickupPoints = const [],
    this.dropPoints = const [],
  });

  String get route => '$from → $to';
}
