import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class FrequencyCard extends StatelessWidget {
  const FrequencyCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: tt.bodyMedium),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
