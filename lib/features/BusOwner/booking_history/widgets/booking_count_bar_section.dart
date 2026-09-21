import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookingCountBarSection extends StatelessWidget {
  const BookingCountBarSection({
    required this.count,
    required this.onExport,
    super.key,
  });

  final int count;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasBookings = count > 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Text('Booking Results', style: tt.titleMedium),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$count ${count == 1 ? 'Booking' : 'Bookings'}',
                  style: tt.titleMedium,
                ),
                OutlinedButton.icon(
                  onPressed: onExport,
                  icon: Icon(
                    Icons.download_outlined,
                    size: 18,
                    color: hasBookings ? AppColors.primary : AppColors.textDisabled,
                  ),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        hasBookings ? AppColors.primary : AppColors.textDisabled,
                    side: BorderSide(
                      color: hasBookings ? AppColors.primary : AppColors.textDisabled,
                    ),
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
          ),
        ],
      ),
    );
  }
}
