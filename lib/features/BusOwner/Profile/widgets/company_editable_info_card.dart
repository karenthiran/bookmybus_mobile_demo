import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_theme.dart';

/// A reusable editable card widget for company information managed by bus owners.
/// 
/// This widget displays editable company details in a card format including
/// contact information and logo upload functionality.
class CompanyEditableInfoCard extends StatefulWidget {
  /// Creates a [CompanyEditableInfoCard] widget.
  const CompanyEditableInfoCard({
    super.key,
    required this.primaryContactNo,
    required this.contactPerson,
    required this.website,
    this.logoImagePath,
    required this.onPrimaryContactNoChanged,
    required this.onContactPersonChanged,
    required this.onWebsiteChanged,
    required this.onLogoUpload,
  });

  /// Initial value for primary contact number.
  final String primaryContactNo;

  /// Initial value for contact person name.
  final String contactPerson;

  /// Initial value for website URL.
  final String website;

  /// Path to the uploaded logo image.
  final String? logoImagePath;

  /// Callback when primary contact number changes.
  final Function(String) onPrimaryContactNoChanged;

  /// Callback when contact person changes.
  final Function(String) onContactPersonChanged;

  /// Callback when website changes.
  final Function(String) onWebsiteChanged;

  /// Callback when logo file is selected.
  final Function() onLogoUpload;

  @override
  State<CompanyEditableInfoCard> createState() =>
      _CompanyEditableInfoCardState();
}

class _CompanyEditableInfoCardState extends State<CompanyEditableInfoCard> {
  late TextEditingController _primaryContactController;
  late TextEditingController _contactPersonController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _primaryContactController = TextEditingController(text: widget.primaryContactNo);
    _contactPersonController = TextEditingController(text: widget.contactPerson);
    _websiteController = TextEditingController(text: widget.website);
  }

  @override
  void dispose() {
    _primaryContactController.dispose();
    _contactPersonController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Primary Contact No Field
          _buildTextField(
            label: 'Primary Contact No',
            controller: _primaryContactController,
            hintText: 'e.g., +94771234567',
            isRequired: true,
            onChanged: widget.onPrimaryContactNoChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Contact Person Field
          _buildTextField(
            label: 'Contact Person',
            controller: _contactPersonController,
            hintText: 'Enter contact person name',
            onChanged: widget.onContactPersonChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Website Field
          _buildTextField(
            label: 'Website',
            controller: _websiteController,
            hintText: 'e.g., https://yourcompany.lk',
            onChanged: widget.onWebsiteChanged,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Logo Uploader Box
          _buildLogoUploader(),
        ],
      ),
    );
  }

  /// Builds the header section with title and subtitle.
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Editable (Bus Owner)',
          style: AppTextTheme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Manage your company information and contact details.',
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds a text input field.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppTextTheme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTextTheme.textTheme.labelLarge?.copyWith(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            hintText: hintText,
            hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the logo uploader section with dashed border.
  Widget _buildLogoUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Logo',
          style: AppTextTheme.textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: DashedBorder(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Choose File Button
                  ElevatedButton(
                    onPressed: widget.onLogoUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: Text(
                      'Choose File',
                      style: AppTextTheme.textTheme.labelLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Preview Placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.section,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: widget.logoImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.file(
                              File(widget.logoImagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Preview',
                                style: AppTextTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A custom widget to draw a dashed border.
class DashedBorder extends StatelessWidget {
  const DashedBorder({
    super.key,
    required this.child,
    this.dashWidth = 5,
    this.dashSpace = 5,
    this.strokeWidth = 2,
    this.color = AppColors.border,
  });

  final Widget child;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        strokeWidth: strokeWidth,
        color: color,
      ),
      child: child,
    );
  }
}

/// Custom painter to draw dashed borders.
class DashedBorderPainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  DashedBorderPainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    final dashPeriod = dashWidth + dashSpace;

    // Draw dashed borders
    _drawDashedLine(canvas, paint, 0, 0, size.width, 0, dashPeriod);
    _drawDashedLine(canvas, paint, size.width, 0, size.width, size.height, dashPeriod);
    _drawDashedLine(canvas, paint, size.width, size.height, 0, size.height, dashPeriod);
    _drawDashedLine(canvas, paint, 0, size.height, 0, 0, dashPeriod);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, double x1, double y1, double x2, double y2, double dashPeriod) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    final distance = sqrt(dx * dx + dy * dy);
    final dashCount = (distance / dashPeriod).ceil();

    for (int i = 0; i < dashCount; i++) {
      final start = i * dashPeriod;
      final end = start + dashWidth;

      final startX = x1 + (dx / distance) * start;
      final startY = y1 + (dy / distance) * start;
      final endX = x1 + (dx / distance) * end.clamp(0, distance);
      final endY = y1 + (dy / distance) * end.clamp(0, distance);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) => false;
}
