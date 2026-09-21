class BusRouteModel {
  const BusRouteModel({
    required this.from,
    required this.to,
    required this.operatorName,
    required this.busType,
    required this.frequency,
    required this.departureHour,
    required this.departureMinute,
    this.imageUrl,
  });

  final String from;
  final String to;

  String get routeName => '$from ➔ $to';

  final String operatorName;
  final String busType;
  final String frequency;

  /// Scheduled departure hour in 24-hour format (0–23).
  final int departureHour;

  /// Scheduled departure minute (0–59).
  final int departureMinute;

  final String? imageUrl;
}
