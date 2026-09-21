import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/models/call_booking_model.dart';
import 'package:flutter/material.dart';

class BusTripCard extends StatelessWidget {
  const BusTripCard({
    required this.trip,
    required this.isSelected,
    required this.onTap,
  });

  final CallBusTripModel trip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.section : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? AppShadows.card : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: bus info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bus name + number
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${trip.busName} ${trip.busNumber}',
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Departure time
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        trip.departureTime,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Route
                  Row(
                    children: [
                      Text(
                        trip.from,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 12, color: AppColors.primary),
                      ),
                      Text(
                        trip.to,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Right: price + seats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'LKR ${trip.pricePerSeat.toStringAsFixed(0)} / seat',
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    '${trip.seatsLeft} seats left',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: AppColors.primary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
