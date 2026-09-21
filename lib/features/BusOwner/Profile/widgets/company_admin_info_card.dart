import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_theme.dart';

/// A reusable read-only card widget displaying company administrative information.
/// 
/// This widget displays company admin details in a clean, professional card format.
/// All input fields are disabled to prevent user editing.
/// 
/// The layout is responsive - on larger screens (tablets/desktop), the registration
/// number and approval status are displayed side-by-side. On mobile, they stack vertically.
class CompanyAdminInfoCard extends StatelessWidget {
  /// Creates a [CompanyAdminInfoCard] widget.
  const CompanyAdminInfoCard({
    super.key,
    required this.companyName,
    required this.companyEmail,
    required this.registrationNumber,
    required this.approvalStatus,
  });

  /// The company's name to display.
  final String companyName;

  /// The company's email address to display.
  final String companyEmail;

  /// The company's registration number to display.
  final String registrationNumber;

  /// The company's approval status to display (e.g., 'Approved', 'Pending').
  final String approvalStatus;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

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

          // Company Name Field
          _buildReadOnlyTextField(
            label: 'Company Name',
            value: companyName,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Company Email Field
          _buildReadOnlyTextField(
            label: 'Company Email',
            value: companyEmail,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Registration Number and Approval Status
          if (isMobile)
            // Mobile: Stack vertically
            Column(
              children: [
                _buildReadOnlyTextField(
                  label: 'Registration Number',
                  value: registrationNumber,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildReadOnlyTextField(
                  label: 'Approval Status',
                  value: approvalStatus,
                ),
              ],
            )
          else
            // Tablet/Desktop: Display in row
            Row(
              children: [
                Expanded(
                  child: _buildReadOnlyTextField(
                    label: 'Registration Number',
                    value: registrationNumber,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: _buildReadOnlyTextField(
                    label: 'Approval Status',
                    value: approvalStatus,
                  ),
                ),
              ],
            ),
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
          'Admin-only (Read-only)',
          style: AppTextTheme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'These fields are managed by platform admins.',
          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds a read-only text field with consistent styling.
  Widget _buildReadOnlyTextField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          enabled: false,
          controller: TextEditingController(text: value),
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
