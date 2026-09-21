import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'bus_form_fields.dart';

const _sriLankanCities = [
  'Colombo', 'Kandy', 'Galle', 'Jaffna', 'Negombo', 'Trincomalee',
  'Batticaloa', 'Anuradhapura', 'Polonnaruwa', 'Kurunegala', 'Ratnapura',
  'Badulla', 'Matara', 'Hambantota', 'Vavuniya', 'Mannar', 'Ampara',
  'Kalmunai', 'Nuwara Eliya', 'Matale', 'Puttalam', 'Chilaw', 'Kegalle',
  'Monaragala', 'Mullaitivu', 'Kilinochchi', 'Dambulla', 'Hikkaduwa',
  'Weligama', 'Tangalle', 'Kalutara', 'Panadura', 'Moratuwa', 'Gampaha',
];

class RouteInfoSection extends StatefulWidget {
  const RouteInfoSection({
    super.key,
    required this.fromController,
    required this.toController,
    this.fromErrorText,
    this.toErrorText,
    this.onFromChanged,
    this.onToChanged,
  });

  final TextEditingController fromController;
  final TextEditingController toController;
  final String? fromErrorText;
  final String? toErrorText;
  final ValueChanged<String>? onFromChanged;
  final ValueChanged<String>? onToChanged;

  @override
  State<RouteInfoSection> createState() => _RouteInfoSectionState();
}

class _RouteInfoSectionState extends State<RouteInfoSection> {
  String? _fromError;
  String? _toError;

  String? get _effectiveFromError => widget.fromErrorText ?? _fromError;
  String? get _effectiveToError => widget.toErrorText ?? _toError;

  void _validate() {
    setState(() {
      _fromError = widget.fromController.text.trim().isEmpty ? 'Route From is required.' : null;
      _toError = widget.toController.text.trim().isEmpty ? 'Route To is required.' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Route Information', style: tt.titleMedium),
        const SizedBox(height: AppSpacing.xl),
        _RouteAutocompleteField(
          label: 'From',
          controller: widget.fromController,
          hint: 'Start typing: C → Co → Col…',
          errorText: _effectiveFromError,
          onChanged: (v) {
            setState(() => _fromError = null);
            widget.onFromChanged?.call(v);
          },
          onEditingComplete: _validate,
        ),
        const SizedBox(height: AppSpacing.lg),
        _RouteAutocompleteField(
          label: 'To',
          controller: widget.toController,
          hint: 'Start typing: K → Ka → Kan…',
          errorText: _effectiveToError,
          onChanged: (v) {
            setState(() => _toError = null);
            widget.onToChanged?.call(v);
          },
          onEditingComplete: _validate,
        ),
      ],
    );
  }
}

class _RouteAutocompleteField extends StatelessWidget {
  const _RouteAutocompleteField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.errorText,
    required this.onChanged,
    required this.onEditingComplete,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;

  static const _fillColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequiredLabel(label),
        Autocomplete<String>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return const [];
            return _sriLankanCities.where(
              (c) => c.toLowerCase().startsWith(value.text.toLowerCase()),
            );
          },
          onSelected: (value) {
            controller.text = value;
            onChanged(value);
          },
          fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
            // Keep external controller in sync
            fieldController.text = controller.text;
            fieldController.addListener(() => controller.text = fieldController.text);
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.words,
              onChanged: onChanged,
              onEditingComplete: () {
                onEditingComplete();
                onFieldSubmitted();
              },
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
                suffixIcon: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textHint),
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
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final city = options.elementAt(index);
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_city_outlined, size: 16, color: AppColors.textSecondary),
                      title: Text(city, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary)),
                      onTap: () => onSelected(city),
                    );
                  },
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel(this.text);
  final String text;

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
          children: const [
            TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
      ),
    );
  }
}
