import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class StepNavBar extends StatelessWidget {
  const StepNavBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
    this.onSubmit,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback? onSubmit;

  bool get _isFirst => currentStep == 0;
  bool get _isLast => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (!_isFirst) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: FilledButton(
              onPressed: _isLast ? (onSubmit ?? onNext) : onNext,
              style: FilledButton.styleFrom(
                backgroundColor: _isLast ? AppColors.success : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLast) ...[
                    const Icon(Icons.check_circle_outline_rounded, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(_isLast ? 'Add Bus to System' : 'Next'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
