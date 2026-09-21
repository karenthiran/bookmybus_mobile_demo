import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class AmenityChip extends StatelessWidget {
  const AmenityChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: tt.bodyMedium?.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.check_rounded, size: 14, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
