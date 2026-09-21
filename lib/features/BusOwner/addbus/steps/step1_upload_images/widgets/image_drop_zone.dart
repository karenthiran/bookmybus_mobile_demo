import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class ImageDropZone extends StatelessWidget {
  const ImageDropZone({super.key, this.onBrowse});

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.info.withOpacity(0.4),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cloud_upload_outlined, size: 32, color: AppColors.info),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Drag and drop images here',
            style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Supports JPG, PNG up to 10MB each', style: tt.bodyMedium?.copyWith(color: AppColors.textHint)),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: onBrowse ?? () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            child: const Text('Browse File'),
          ),
        ],
      ),
    );
  }
}
