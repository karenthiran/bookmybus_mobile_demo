import 'package:bookmybus/shared/widgets/confirm_booking_card.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step4ConfirmPage extends StatelessWidget {
  const Step4ConfirmPage({super.key, required this.booking});

  final CallBookingModel booking;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final trip = booking.selectedTrip!;
    final seats = booking.selectedSeats;
    final total = seats.length * trip.pricePerSeat;

    return ConfirmBookingCard(
      busName: trip.busName,
      busNumber: trip.busNumber,
      route: trip.route,
      departureTime: trip.departureTime,
      travelDate: _fmtDate(booking.travelDate!),
      seats: seats,
      seatGenders: booking.seatGenders,
      passengerName: booking.passengerName,
      passengerPhone: booking.passengerPhone,
      passengerEmail: booking.passengerEmail,
      pickupPoint: booking.pickupPoint,
      dropPoint: booking.dropPoint,
      totalAmount: total,
    );
  }
}

