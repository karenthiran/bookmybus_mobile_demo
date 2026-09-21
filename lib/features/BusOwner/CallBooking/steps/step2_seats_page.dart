import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_2/trip_info_bar.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_2/header_row.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_2/legend_row.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_2/selection_summary.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_2/seat_hold_countdown_banner.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step2SeatsPage extends StatefulWidget {
  const Step2SeatsPage({
    super.key,
    required this.booking,
    required this.onChanged,
  });

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step2SeatsPage> createState() => _Step2SeatsPageState();
}

class _Step2SeatsPageState extends State<Step2SeatsPage> {
  Set<int> _pendingSeatSelection = {};
  bool _showCountdown = false;

  void _onSeatSelected(List<int> seats) {
    final previous = widget.booking.selectedSeats.toSet();
    final next = seats.toSet();
    final newlySelected = next.difference(previous).toList();

    if (newlySelected.isNotEmpty && !_showCountdown) {
      setState(() => _showCountdown = true);
    }

    final kept = <int, String>{};
    for (final seat in seats) {
      final gender = widget.booking.seatGenders[seat];
      if (gender != null) {
        kept[seat] = gender;
      }
    }

    widget.booking.selectedSeats = List<int>.from(seats);
    widget.booking.seatGenders = kept;
    widget.onChanged();

    if (newlySelected.isNotEmpty) {
      final seat = newlySelected.first;
      if (!widget.booking.seatGenders.containsKey(seat)) {
        _pendingSeatSelection = {seat};
        WidgetsBinding.instance.addPostFrameCallback((_) => _showGenderPicker(seat));
      }
    }
  }

  void _assignGender(int seat, String gender) {
    final next = Map<int, String>.from(widget.booking.seatGenders)
      ..[seat] = gender;
    widget.booking.seatGenders = next;
    _pendingSeatSelection = {};
    setState(() {});
    widget.onChanged();
  }

  Future<void> _showGenderPicker(int seat) async {
    final selected = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Select gender'),
        content: const Text('Choose the passenger gender for this seat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('Male'),
            child: const Text('Male'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('Female'),
            child: const Text('Female'),
          ),
        ],
      ),
    );

    if (selected != null) {
      _assignGender(seat, selected);
    } else {
      widget.booking.selectedSeats = List<int>.from(
        widget.booking.selectedSeats.where((value) => value != seat),
      );
      _pendingSeatSelection = {};
      setState(() {});
      widget.onChanged();
    }
  }

  void _removeSeat(int seat) {
    final next = Map<int, String>.from(widget.booking.seatGenders);
    next.remove(seat);
    widget.booking.seatGenders = next;
    widget.booking.selectedSeats.remove(seat);
    setState(() {});
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.booking.selectedTrip!;
    final selected = widget.booking.selectedSeats;
    final total = selected.length * trip.pricePerSeat;
    final missingGender = selected
        .where((seat) => !widget.booking.seatGenders.containsKey(seat))
        .toList();

    final validSelectedSeats = Set<int>.from(selected)
      .difference(_pendingSeatSelection)
      .toSet();

    final seatStatuses = <int, SeatStatus>{};
    for (final seat in List<int>.generate(8, (index) => index + 1)) {
      seatStatuses[seat] = SeatStatus.blockedMale;
    }
    for (final seat in [9, 10, 11, 12]) {
      seatStatuses[seat] = SeatStatus.blockedFemale;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripInfoBar(
            busName: trip.busName,
            from: trip.from,
            to: trip.to,
            departureTime: trip.departureTime,
          ),
          const SizedBox(height: AppSpacing.lg),
          HeaderRow(
            selectedCount: selected.length,
            totalFare: total,
          ),
          const SizedBox(height: AppSpacing.sm),
          const LegendRow(),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF2F5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD8DEE8)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 32, 18, 18),
                  child: TwoByTwo45SeatLayout(
                    seatStatuses: seatStatuses,
                    selectedSeats: validSelectedSeats,
                    onSeatSelected: _onSeatSelected,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D4ED8),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'DRV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 2,
                      color: const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_showCountdown && validSelectedSeats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: SeatHoldCountdownBanner(
                onTimerExpired: () => setState(() => _showCountdown = false),
              ),
            ),
          if (validSelectedSeats.isNotEmpty)
            SelectionSummary(
              selected: validSelectedSeats.toList()..sort(),
              seatGenders: widget.booking.seatGenders,
              onGenderSelected: _assignGender,
              onRemove: _removeSeat,
            ),
          if (missingGender.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4D5),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFFE4B95F)),
              ),
              child: Text(
                'Please select a gender (Male/Female) for every seat before continuing. Seats without a gender are not held and you can\'t proceed to the next step.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF7A4F00),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}
