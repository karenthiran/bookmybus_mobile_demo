import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CallBookingPageHeader extends StatelessWidget {
  const CallBookingPageHeader({required this.onViewRecent});

  final VoidCallback onViewRecent;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Call / Walk-in Booking', style: tt.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Create an instant confirmed booking for a customer',
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onViewRecent,
            icon: const Icon(Icons.history_rounded, size: 18),
            label: const Text('View Recent'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
