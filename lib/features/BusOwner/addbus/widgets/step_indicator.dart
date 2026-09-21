import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<({String label, IconData icon})> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final done = (i ~/ 2) < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? AppColors.primary : AppColors.border,
              ),
            );
          }

          final idx = i ~/ 2;
          final isDone = idx < currentStep;
          final isActive = idx == currentStep;

          return Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone || isActive ? AppColors.primary : AppColors.section,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: AppColors.primaryLight, width: 2)
                      : null,
                ),
                child: Icon(
                  isDone ? Icons.check_rounded : steps[idx].icon,
                  size: 18,
                  color: isDone || isActive ? AppColors.white : AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                steps[idx].label,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  color: isActive ? AppColors.primary : AppColors.textHint,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
