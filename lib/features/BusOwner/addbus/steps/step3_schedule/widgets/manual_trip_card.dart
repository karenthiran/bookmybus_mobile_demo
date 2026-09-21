import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'schedule_time_fields.dart';

class ManualTripCard extends StatelessWidget {
  const ManualTripCard({
    super.key,
    required this.title,
    required this.isUpTrip,
    required this.departureController,
    required this.arrivalController,
    required this.arrivesNextDay,
    required this.onArrivesNextDayChanged,
    this.onDepartureTap,
    this.onArrivalTap,
    this.departureErrorText,
    this.arrivalErrorText,
    this.onDepartureChanged,
    this.onArrivalChanged,
  });

  final String title;
  final bool isUpTrip;
  final TextEditingController departureController;
  final TextEditingController arrivalController;
  final bool arrivesNextDay;
  final ValueChanged<bool?> onArrivesNextDayChanged;
  final VoidCallback? onDepartureTap;
  final VoidCallback? onArrivalTap;
  final String? departureErrorText;
  final String? arrivalErrorText;
  final ValueChanged<String>? onDepartureChanged;
  final ValueChanged<String>? onArrivalChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final accentColor = isUpTrip ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUpTrip ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 14,
                      color: accentColor,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      isUpTrip ? 'Up Trip' : 'Down Trip (Return)',
                      style: tt.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          ScheduleTimeFields(
            departureController: departureController,
            arrivalController: arrivalController,
            arrivesNextDay: arrivesNextDay,
            onArrivesNextDayChanged: onArrivesNextDayChanged,
            onDepartureTap: onDepartureTap,
            onArrivalTap: onArrivalTap,
            departureErrorText: departureErrorText,
            arrivalErrorText: arrivalErrorText,
            onDepartureChanged: onDepartureChanged,
            onArrivalChanged: onArrivalChanged,
          ),
        ],
      ),
    );
  }
}
