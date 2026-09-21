import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BusFieldLabel extends StatelessWidget {
  const BusFieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
      ),
    );
  }
}

class BusFieldHint extends StatelessWidget {
  const BusFieldHint(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textHint,
              fontSize: 11,
            ),
      ),
    );
  }
}

class BusFormField extends StatelessWidget {
  const BusFormField({
    super.key,
    required this.controller,
    required this.hint,
    required this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const _fillColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
            suffixIcon: Icon(suffixIcon, size: 18, color: AppColors.textHint),
            filled: true,
            fillColor: _fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.primary, width: 1.5),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class BusPhoneField extends StatelessWidget {
  const BusPhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const _fillColor = Color(0xFFF8FAFC);
  static const _whatsappGreen = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]'))],
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g. 77 123 4567',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
            prefixIcon: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.section,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇱🇰', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '+94',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            suffixIcon: const Icon(Icons.phone, size: 20, color: _whatsappGreen),
            filled: true,
            fillColor: _fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.primary, width: 1.5),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
