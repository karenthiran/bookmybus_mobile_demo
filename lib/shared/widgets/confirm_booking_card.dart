import 'package:flutter/material.dart';
import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';

class ConfirmBookingCard extends StatelessWidget {
  const ConfirmBookingCard({
    super.key,
    required this.busName,
    required this.busNumber,
    required this.route,
    required this.departureTime,
    required this.travelDate,
    required this.seats,
    required this.seatGenders,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerEmail,
    required this.pickupPoint,
    required this.dropPoint,
    required this.totalAmount,
  });

  final String busName;
  final String busNumber;
  final String route;
  final String departureTime;
  final String travelDate;
  final List<int> seats;
  final Map<int, String> seatGenders;
  final String passengerName;
  final String passengerPhone;
  final String passengerEmail;
  final String pickupPoint;
  final String dropPoint;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Trip Details ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trip Details',
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),
                _DetailRow('Bus', '$busName $busNumber', tt),
                _DetailRow('Route', route, tt),
                _DetailRow('Travel Date', travelDate, tt),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text('Departure Time', style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    const Spacer(),
                    Text(departureTime, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _SeatGenderRow(seats: seats, seatGenders: seatGenders, tt: tt),
                const SizedBox(height: AppSpacing.md),
                _DetailRow('Pickup', pickupPoint, tt),
                _DetailRow('Drop', dropPoint, tt),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Passenger Details ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Passenger Details',
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),
                _DetailRow('Full Name', passengerName, tt),
                _DetailRow('Contact Number', passengerPhone, tt),
                if (passengerEmail.isNotEmpty)
                  _DetailRow('Email', passengerEmail, tt),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Total Amount ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount',
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text('LKR ${totalAmount.toStringAsFixed(0)}',
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF16A34A),
                    )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Warning Notice ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: const Color(0xFFECC94B)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFF59E0B)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cash Collection',
                          style: tt.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF92400E),
                          )),
                      const SizedBox(height: 4),
                      Text('Payment will be collected at pickup. SMS confirmation will be sent to the passenger.',
                          style: tt.bodySmall?.copyWith(color: const Color(0xFF92400E))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, this.tt);

  final String label;
  final String value;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
          Text(value,
              style: tt.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _SeatGenderRow extends StatelessWidget {
  const _SeatGenderRow({
    required this.seats,
    required this.seatGenders,
    required this.tt,
  });

  final List<int> seats;
  final Map<int, String> seatGenders;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    final seatTags = seats.map((seat) {
      final gender = seatGenders[seat] ?? '';
      return '#$seat ($gender)';
    }).join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Seats', style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
          Expanded(
            child: Text(seatTags,
                textAlign: TextAlign.end,
                style: tt.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}
