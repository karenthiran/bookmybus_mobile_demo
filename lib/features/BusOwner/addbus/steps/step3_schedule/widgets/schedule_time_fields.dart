import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ScheduleTimeFields extends StatelessWidget {
  const ScheduleTimeFields({
    super.key,
    required this.departureController,
    required this.arrivalController,
    required this.arrivesNextDay,
    required this.onArrivesNextDayChanged,
    this.onDepartureTap,
    this.onArrivalTap,
    this.departureErrorText,
    this.arrivalErrorText,
    this.onDepartureChanged,
    this.onArrivalChanged,
  });

  final TextEditingController departureController;
  final TextEditingController arrivalController;
  final bool arrivesNextDay;
  final ValueChanged<bool?> onArrivesNextDayChanged;
  final VoidCallback? onDepartureTap;
  final VoidCallback? onArrivalTap;
  final String? departureErrorText;
  final String? arrivalErrorText;
  final ValueChanged<String>? onDepartureChanged;
  final ValueChanged<String>? onArrivalChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _TimeField(
                label: 'Departure Time',
                required: true,
                controller: departureController,
                onTap: onDepartureTap,
                errorText: departureErrorText,
                onChanged: onDepartureChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _TimeField(
                label: 'Arrival Time',
                required: true,
                controller: arrivalController,
                onTap: onArrivalTap,
                errorText: arrivalErrorText,
                onChanged: onArrivalChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _NextDayCheckbox(
          value: arrivesNextDay,
          onChanged: onArrivesNextDayChanged,
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.controller,
    this.required = false,
    this.onTap,
    this.errorText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final bool required;
  final VoidCallback? onTap;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const _fillColor = Color(0xFFF8FAFC);
  static const _borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, required: required),
        GestureDetector(
          onTap: () {
            onTap?.call();
            onChanged?.call(controller.text);
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              readOnly: true,
              style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '--:-- --',
                hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                suffixIcon: const Icon(Icons.access_time_rounded,
                    size: 18, color: AppColors.textHint),
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
            ),
          ),
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

class _NextDayCheckbox extends StatelessWidget {
  const _NextDayCheckbox({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Arrives next day?',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

// Shared label widget used across schedule widgets
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: RichText(
        text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
