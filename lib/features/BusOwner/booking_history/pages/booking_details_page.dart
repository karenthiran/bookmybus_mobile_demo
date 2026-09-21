import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

import '../models/booking_history_model.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    final pricePerSeat = booking.fare / booking.seats.length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Booking Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status Banner ──────────────────────────────────
            _StatusBanner(status: booking.status),
            const SizedBox(height: AppSpacing.lg),

            // ── Ticket Reference & Booked At ───────────────────
            _Section(
              title: 'Booking Details',
              icon: Icons.confirmation_number_outlined,
              children: [
                _Row(label: 'Ticket Reference', value: booking.ticketRef.toUpperCase()),
                _Row(label: 'Booked At', value: booking.bookedOn),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Passenger Information ──────────────────────────
            _Section(
              title: 'Passenger Information',
              icon: Icons.person_outline,
              children: [
                _Row(label: 'Name', value: booking.passengerName),
                _Row(label: 'Contact Number', value: booking.passengerPhone),
                _Row(label: 'NIC', value: booking.passengerNic),
                _Row(label: 'Email', value: booking.passengerEmail),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Bus & Trip Details ─────────────────────────────
            _Section(
              title: 'Bus & Trip Details',
              icon: Icons.directions_bus_outlined,
              children: [
                _Row(label: 'Bus Name', value: booking.busName),
                _Row(label: 'Bus Number', value: booking.busNumber),
                _Row(label: 'Route', value: booking.route),
                _Row(label: 'Travel Date', value: booking.travelDate),
                _Row(label: 'Departure Time', value: booking.departureTime),
                _Row(label: 'Pickup Location', value: booking.pickup),
                _Row(label: 'Drop Location', value: booking.drop),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Seats & Payment ────────────────────────────────
            _Section(
              title: 'Seats & Payment',
              icon: Icons.receipt_long_outlined,
              children: [
                _SeatsRow(seats: booking.seats),
                _Row(label: 'Seat Count', value: '${booking.seats.length} ${booking.seats.length == 1 ? 'Seat' : 'Seats'}'),
                _Row(label: 'Price per Seat', value: 'LKR ${pricePerSeat.toStringAsFixed(2)}'),
                _Row(
                  label: 'Total Amount',
                  value: 'LKR ${booking.fare.toStringAsFixed(2)}',
                  valueColor: AppColors.primary,
                  bold: true,
                ),
                _Row(label: 'Payment Method', value: booking.paymentMethod),
                _Row(
                  label: 'Booking Status',
                  value: booking.status[0].toUpperCase() + booking.status.substring(1),
                  valueColor: _statusColor(booking.status),
                  bold: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) => switch (status) {
        'confirmed' => const Color(0xFF15803D),
        'cancelled' => AppColors.error,
        _ => const Color(0xFFB45309),
      };
}

// ── Status Banner ─────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, textColor, icon, label) = switch (status) {
      'confirmed' => (
          AppColors.successLight,
          const Color(0xFF15803D),
          Icons.check_circle_outline,
          'Booking Confirmed',
        ),
      'cancelled' => (
          AppColors.errorLight,
          AppColors.error,
          Icons.cancel_outlined,
          'Booking Cancelled',
        ),
      _ => (
          AppColors.warningLight,
          const Color(0xFFB45309),
          Icons.hourglass_empty_outlined,
          'Booking Pending',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.section,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primaryLight),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Seats Row ─────────────────────────────────────────────────────────────────

class _SeatsRow extends StatelessWidget {
  const _SeatsRow({required this.seats});
  final List<String> seats;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              'Seat Number(s)',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: seats.map((s) {
                final isFemale = s.toLowerCase().contains('female');
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isFemale ? AppColors.seatFemale : AppColors.seatBooked,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    s,
                    style: tt.labelSmall?.copyWith(
                      color: isFemale ? const Color(0xFFBE185D) : AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
