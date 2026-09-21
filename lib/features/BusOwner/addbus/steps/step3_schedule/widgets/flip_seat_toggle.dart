import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class FlipSeatToggle extends StatelessWidget {
  const FlipSeatToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: value ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: value ? AppColors.primary : const Color(0xFFE2E8F0),
          width: value ? 1.8 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flip Seat Layout',
                  style: tt.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: value ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'When enabled, seat numbers are displayed in reverse order.',
                  style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
