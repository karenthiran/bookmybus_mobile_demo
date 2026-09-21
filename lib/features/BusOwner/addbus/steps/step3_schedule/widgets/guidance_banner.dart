import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class GuidanceBanner extends StatelessWidget {
  const GuidanceBanner({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.info.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.info),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
