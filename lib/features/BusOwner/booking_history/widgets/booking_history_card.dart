import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/booking_history_model.dart';

class BookingHistoryCard extends StatelessWidget {
  const BookingHistoryCard({
    super.key,
    required this.booking,
    this.onViewBooking,
  });

  final BookingHistoryModel booking;
  final VoidCallback? onViewBooking;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Section ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ref badge + Status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RefBadge(ref: booking.ticketRef),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Passenger name
                Text(
                  booking.passengerName,
                  style: tt.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // ── Dashed Divider ───────────────────────────────────
          _DashedDivider(),

          // ── Middle Section: 2-column detail grid ─────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DetailCell(
                        icon: Icons.route_outlined,
                        label: 'ROUTE',
                        value: booking.route,
                        valueStyle: tt.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _DetailCell(
                        icon: Icons.calendar_today_outlined,
                        label: 'TRAVEL DATE',
                        value: booking.travelDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _DetailCell(
                        icon: Icons.event_seat_outlined,
                        label: 'SEATS',
                        value: booking.seats.join(', '),
                      ),
                    ),
                    Expanded(
                      child: _DetailCell(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'AMOUNT',
                        value: 'LKR ${booking.fare.toStringAsFixed(0)}',
                        valueStyle: tt.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Dashed Divider ───────────────────────────────────
          _DashedDivider(),

          // ── Footer ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // _AvatarStack(name: booking.passengerName),
                GestureDetector(
                  onTap: onViewBooking,
                  child: Row(
                    children: [
                      Text(
                        'View Details',
                        style: tt.labelLarge?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ref Badge ─────────────────────────────────────────────────────────────────

class _RefBadge extends StatelessWidget {
  const _RefBadge({required this.ref});
  final String ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        'REF: ${ref.toUpperCase()}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryLight,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
      ),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, textColor, label) = switch (status) {
      'confirmed' => (AppColors.successLight, const Color(0xFF15803D), 'CONFIRMED'),
      'cancelled'  => (AppColors.errorLight, AppColors.error, 'CANCELLED'),
      'pending'    => (AppColors.warningLight, const Color(0xFFB45309), 'PENDING'),
      _            => (AppColors.section, AppColors.textSecondary, status.toUpperCase()),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

// ── Dashed Divider ────────────────────────────────────────────────────────────

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(),
        size: const Size(double.infinity, 1),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Detail Cell ───────────────────────────────────────────────────────────────

class _DetailCell extends StatelessWidget {
  const _DetailCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.section,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 14, color: AppColors.primaryLight),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 10,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: valueStyle ??
                    tt.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Avatar Stack ──────────────────────────────────────────────────────────────

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.name});
  final String name;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 28,
      child: Stack(
        children: [
          _circle(AppColors.chart5, _initials, 0),
          _circle(AppColors.chart4, '', 18),
          _circle(AppColors.chart3, '', 36),
        ],
      ),
    );
  }

  Widget _circle(Color color, String text, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
        alignment: Alignment.center,
        child: text.isNotEmpty
            ? Text(
                text,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
    );
  }
}
