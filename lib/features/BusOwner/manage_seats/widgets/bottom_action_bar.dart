import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Bottom action bar with Cancel and Save buttons.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.onCancel,
    required this.onSave,
    this.cancelLabel = 'Cancel',
    this.saveLabel = 'Save Changes',
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String cancelLabel;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(cancelLabel),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                saveLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
