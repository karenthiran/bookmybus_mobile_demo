import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


const _busTypes = ['Super Luxury', 'Luxury', 'Semi-Luxury', 'Normal'];

class BusTypeDropdown extends StatelessWidget {
  const BusTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  static const _fillColor = Color(0xFFF8FAFC);
  static const _borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          hint: Text(
            'Select Bus Type',
            style: tt.bodyMedium?.copyWith(color: AppColors.textHint),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textHint),
          style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
          dropdownColor: AppColors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: _fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: _borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : _borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.primary, width: 1.5),
            ),
          ),
          items: _busTypes
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: tt.bodySmall?.copyWith(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
