import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookingHistoryHeaderSection extends StatelessWidget {
  const BookingHistoryHeaderSection({
    super.key,
    this.companyName = 'Lion Super Line',
    this.title = 'Booking History',
    this.subtitle = 'Review, filter, and export your booking history.',
  });

  final String companyName;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          companyName,
          style: tt.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(title, style: tt.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: tt.bodyMedium,
        ),
      ],
    );
  }
}
