import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Header section displaying seat management title and description.
class ManageSeatHeaderSection extends StatelessWidget {
  const ManageSeatHeaderSection({
    required this.busName,
    super.key,
  });

  final String busName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seat Management – $busName',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Mark seats as unavailable by date or permanently. Booked seats are always read-only.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
