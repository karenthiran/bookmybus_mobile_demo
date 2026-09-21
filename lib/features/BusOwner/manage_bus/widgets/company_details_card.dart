import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class CompanyDetailsCard extends StatelessWidget {
  const CompanyDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.section,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Company Details',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const _ReadOnlyField(label: 'Company', value: 'bus1'),
                const SizedBox(height: AppSpacing.md),
                const _ReadOnlyField(
                  label: 'Company Email',
                  value: 'karank001@gmail.com',
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Contact support to update account details for security purposes.',
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        labelStyle: const TextStyle(color: AppColors.textHint),
      ),
      style: const TextStyle(color: AppColors.textSecondary),
    );
  }
}