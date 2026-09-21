import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'seat_management_card.dart';

/// Section displaying helpful tips about seat management.
class TipsSection extends StatelessWidget {
  const TipsSection({
    this.tips = const [
      'Booked seats cannot be modified by seat management.',
      'Permanent blocks apply to every date for this bus. Use them carefully.',
      'Use Release for N Days to temporarily open permanently-blocked seats for a date window. They revert automatically when the period ends.',
      'Date-range blocks are useful for maintenance windows or temporary seat issues.',
      'Changes apply only after you click Save Changes. Past dates are always protected.',
    ],
    super.key,
  });

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return SeatManagementCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: AppColors.warning,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Helpful Tips',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
