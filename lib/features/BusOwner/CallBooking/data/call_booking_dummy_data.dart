import '../models/call_booking_model.dart';

class CallBookingDummyData {
  CallBookingDummyData._();

  static const List<CallBusTripModel> trips = [
    CallBusTripModel(
      busName: 'THEUEUE',
      busNumber: 'E454P',
      departureTime: '00:33',
      from: 'Trincomalee',
      to: 'Colombo',
      pricePerSeat: 1500,
      seatsLeft: 51,
    ),
    CallBusTripModel(
      busName: 'LION SUPER LINE',
      busNumber: 'NC 5025',
      departureTime: '01:10',
      from: 'Trincomalee',
      to: 'Wellawaththa',
      pricePerSeat: 1850,
      seatsLeft: 24,
    ),
    CallBusTripModel(
      busName: 'WWW RER',
      busNumber: '4545',
      departureTime: '08:08',
      from: 'Trincomalee',
      to: 'Colombo',
      pricePerSeat: 1750,
      seatsLeft: 48,
    ),
    CallBusTripModel(
      busName: 'LION SUPER LINE',
      busNumber: 'NC-5025',
      departureTime: '10:40',
      from: 'Colombo',
      to: 'Trincomalee',
      pricePerSeat: 1850,
      seatsLeft: 28,
    ),
  ];
}
