import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({
    super.key,
    required this.label,
    required this.icon,
    this.onDelete,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                color: AppColors.section,
                child: Icon(icon, size: 40, color: AppColors.primaryLight),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.md),
                  bottomRight: Radius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                label,
                style: tt.bodyMedium?.copyWith(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: Row(
              children: [
                _ActionIcon(icon: Icons.delete_outline, onTap: onDelete ?? () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Icon(icon, size: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
