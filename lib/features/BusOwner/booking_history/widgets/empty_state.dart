import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookingHistoryEmptyState extends StatelessWidget {
  const BookingHistoryEmptyState({
    super.key,
    this.icon = Icons.receipt_long_outlined,
    this.title = 'No bookings found for the selected filters.',
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
