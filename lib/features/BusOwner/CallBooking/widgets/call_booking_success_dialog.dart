import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CallBookingSuccessDialog extends StatelessWidget {
  const CallBookingSuccessDialog({
    super.key,
    required this.onDone,
  });

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.xxl),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 36,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Booking Confirmed!',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'The booking has been created successfully.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
