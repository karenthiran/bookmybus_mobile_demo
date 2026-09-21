class BookingHistoryModel {
  final String ticketRef;
  final String busName;
  final String busNumber;
  final String route;
  final String from;
  final String to;
  final String passengerName;
  final String passengerPhone;
  final String passengerNic;
  final String passengerEmail;
  final String travelDate;
  final String departureTime;
  final List<String> seats; // e.g. ['33 (Male)', '34 (Female)']
  final String pickup;
  final String drop;
  final String bookedOn;
  final double fare;
  final String paymentMethod;
  final String status; // 'confirmed', 'cancelled', 'pending'
  final bool isCallBooking;

  const BookingHistoryModel({
    required this.ticketRef,
    required this.busName,
    required this.busNumber,
    required this.route,
    required this.from,
    required this.to,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerNic,
    required this.passengerEmail,
    required this.travelDate,
    required this.departureTime,
    required this.seats,
    required this.pickup,
    required this.drop,
    required this.bookedOn,
    required this.fare,
    required this.paymentMethod,
    required this.status,
    this.isCallBooking = false,
  });
}
