class AddBusData {
  AddBusData({
    // Step 1
    this.imageUrls = const [],
    // Step 2
    this.busName = '',
    this.registrationNumber = '',
    this.totalSeats = '',
    this.pricePerSeat = '',
    this.whatsappPhone = '',
    this.conductorPhone = '',
    // Step 3 – Route
    this.fromCity = '',
    this.toCity = '',
    // Step 3 – Schedule
    this.frequency = '',
    this.departureTime = '',
    this.arrivalTime = '',
    this.arrivesNextDay = false,
    this.startDate = '',
    this.manualUpDeparture = '',
    this.manualUpArrival = '',
    this.manualUpNextDay = false,
    this.manualDownDeparture = '',
    this.manualDownArrival = '',
    this.manualDownNextDay = false,
    // Step 3 – Bus Config
    this.busType = '',
    this.seatLayout = '',
    this.flipSeatLayout = false,
    // Step 3 – Amenities & Features
    this.amenities = const [],
    this.additionalFeatures = const [],
    // Step 3 – Pickup / Drop
    this.pickupDropPoints = const [],
  });

  // Step 1
  final List<String> imageUrls;

  // Step 2
  final String busName;
  final String registrationNumber;
  final String totalSeats;
  final String pricePerSeat;
  final String whatsappPhone;
  final String conductorPhone;

  // Step 3 – Route
  final String fromCity;
  final String toCity;

  // Step 3 – Schedule
  final String frequency;
  final String departureTime;
  final String arrivalTime;
  final bool arrivesNextDay;
  final String startDate;
  final String manualUpDeparture;
  final String manualUpArrival;
  final bool manualUpNextDay;
  final String manualDownDeparture;
  final String manualDownArrival;
  final bool manualDownNextDay;

  // Step 3 – Bus Config
  final String busType;
  final String seatLayout;
  final bool flipSeatLayout;

  // Step 3 – Amenities & Features
  final List<String> amenities;
  final List<String> additionalFeatures;

  // Step 3 – Pickup / Drop
  final List<Map<String, String>> pickupDropPoints;

  Map<String, dynamic> toJson() => {
        'images': imageUrls,
        'busName': busName,
        'registrationNumber': registrationNumber,
        'totalSeats': totalSeats,
        'pricePerSeat': pricePerSeat,
        'whatsappPhone': whatsappPhone,
        'conductorPhone': conductorPhone,
        'fromCity': fromCity,
        'toCity': toCity,
        'frequency': frequency,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'arrivesNextDay': arrivesNextDay,
        'startDate': startDate,
        'manualUpDeparture': manualUpDeparture,
        'manualUpArrival': manualUpArrival,
        'manualUpNextDay': manualUpNextDay,
        'manualDownDeparture': manualDownDeparture,
        'manualDownArrival': manualDownArrival,
        'manualDownNextDay': manualDownNextDay,
        'busType': busType,
        'seatLayout': seatLayout,
        'flipSeatLayout': flipSeatLayout,
        'amenities': amenities,
        'additionalFeatures': additionalFeatures,
        'pickupDropPoints': pickupDropPoints,
      };
}
