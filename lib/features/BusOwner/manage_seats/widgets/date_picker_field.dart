import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Date/date-range input field for seat management.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    required this.value,
    required this.hint,
    required this.onTap,
    super.key,
  });

  final String value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? hint : value,
                style: TextStyle(
                  fontSize: 14,
                  color: value.isEmpty
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
