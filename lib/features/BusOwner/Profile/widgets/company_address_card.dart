import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_theme.dart';

/// A reusable address card widget for displaying and editing company address information.
/// 
/// This widget displays address details in a card format with an editable badge
/// that can be tapped to enable edit mode.
class CompanyAddressCard extends StatefulWidget {
  /// Creates a [CompanyAddressCard] widget.
  const CompanyAddressCard({
    super.key,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.country,
    required this.onAddressLine1Changed,
    required this.onAddressLine2Changed,
    required this.onCityChanged,
    required this.onProvinceChanged,
    required this.onPostalCodeChanged,
    required this.onCountryChanged,
    required this.onEditablePressed,
  });

  /// Address line 1 value.
  final String addressLine1;

  /// Address line 2 value.
  final String addressLine2;

  /// City value.
  final String city;

  /// Province/State value.
  final String province;

  /// Postal code value.
  final String postalCode;

  /// Country value.
  final String country;

  /// Callback when address line 1 changes.
  final Function(String) onAddressLine1Changed;

  /// Callback when address line 2 changes.
  final Function(String) onAddressLine2Changed;

  /// Callback when city changes.
  final Function(String) onCityChanged;

  /// Callback when province changes.
  final Function(String) onProvinceChanged;

  /// Callback when postal code changes.
  final Function(String) onPostalCodeChanged;

  /// Callback when country changes.
  final Function(String) onCountryChanged;

  /// Callback when editable badge is pressed.
  final Function() onEditablePressed;

  @override
  State<CompanyAddressCard> createState() => _CompanyAddressCardState();
}

class _CompanyAddressCardState extends State<CompanyAddressCard> {
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _addressLine1Controller = TextEditingController(text: widget.addressLine1);
    _addressLine2Controller = TextEditingController(text: widget.addressLine2);
    _cityController = TextEditingController(text: widget.city);
    _provinceController = TextEditingController(text: widget.province);
    _postalCodeController = TextEditingController(text: widget.postalCode);
    _countryController = TextEditingController(text: widget.country);
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
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
          // Header with Title and Editable Badge
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Address Line 1
          _buildTextField(
            label: 'Address Line 1',
            controller: _addressLine1Controller,
            hintText: 'Enter street address',
            onChanged: widget.onAddressLine1Changed,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Address Line 2
          _buildTextField(
            label: 'Address Line 2',
            controller: _addressLine2Controller,
            hintText: 'Apartment, suite, etc. (optional)',
            onChanged: widget.onAddressLine2Changed,
          ),
          const SizedBox(height: AppSpacing.lg),

          // City and Province Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'City',
                  controller: _cityController,
                  hintText: 'Enter city',
                  onChanged: widget.onCityChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _buildTextField(
                  label: 'Province',
                  controller: _provinceController,
                  hintText: 'Enter province',
                  onChanged: widget.onProvinceChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Postal Code and Country Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Postal Code',
                  controller: _postalCodeController,
                  hintText: 'Enter postal code',
                  onChanged: widget.onPostalCodeChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _buildTextField(
                  label: 'Country',
                  controller: _countryController,
                  hintText: 'Enter country',
                  onChanged: widget.onCountryChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the header section with title and editable badge.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Address',
          style: AppTextTheme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Editable Pill Badge
        GestureDetector(
          onTap: widget.onEditablePressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.round),
              border: Border.all(
                color: AppColors.primary,
                width: 1,
              ),
            ),
            child: Text(
              'EDITABLE',
              style: AppTextTheme.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a text input field with consistent styling.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
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
                color: Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
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
}
