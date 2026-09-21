import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'widgets/image_drop_zone.dart';
import 'widgets/image_preview_card.dart';
import 'widgets/upload_progress_bar.dart';

class Step1UploadImagesPage extends StatelessWidget {
  const Step1UploadImagesPage({super.key, this.standalone = true});

  final bool standalone;
  static const _image = (label: 'Bus Image', icon: Icons.directions_bus_outlined);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 1: Upload Bus Images', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Upload exterior and interior images of your bus for passengers to preview.',
            style: tt.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          const ImageDropZone(),
          const SizedBox(height: AppSpacing.xxl),
          Text('Image Preview', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.md),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ImagePreviewCard(label: _image.label, icon: _image.icon),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const UploadProgressBar(fileName: 'bus_exterior.jpg', progress: 0.75),
        ],
      );
    return standalone
        ? SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: content)
        : Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: content);
  }
}

