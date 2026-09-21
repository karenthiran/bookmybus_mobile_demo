import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class RouteField extends StatelessWidget {
  const RouteField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final String label;

  static const _fillColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            label,
            style: tt.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        TextField(
          controller: controller,
          style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
            prefixIcon: Icon(icon, size: 20, color: iconColor),
            filled: true,
            fillColor: _fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
