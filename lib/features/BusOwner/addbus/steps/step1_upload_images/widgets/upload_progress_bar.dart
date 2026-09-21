import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class UploadProgressBar extends StatelessWidget {
  const UploadProgressBar({super.key, required this.fileName, required this.progress});

  final String fileName;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.insert_drive_file_outlined, size: 16, color: AppColors.info),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Uploading $fileName',
                    style: tt.bodyMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: tt.bodyMedium?.copyWith(color: AppColors.info, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.round),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.section,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}
