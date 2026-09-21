import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';


class AdditionalFeaturesInput extends StatefulWidget {
  const AdditionalFeaturesInput({super.key, this.onChanged});

  /// Called with the current list of features on every change.
  final ValueChanged<List<String>>? onChanged;

  @override
  State<AdditionalFeaturesInput> createState() =>
      _AdditionalFeaturesInputState();
}

class _AdditionalFeaturesInputState extends State<AdditionalFeaturesInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final List<String> _features = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commitInput() {
    final parts = _controller.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (parts.isEmpty) return;

    setState(() {
      for (final p in parts) {
        if (!_features.contains(p)) _features.add(p);
      }
      _controller.clear();
    });
    widget.onChanged?.call(List.unmodifiable(_features));
  }

  void _remove(String feature) {
    setState(() => _features.remove(feature));
    widget.onChanged?.call(List.unmodifiable(_features));
  }

  void _onChanged(String value) {
    if (value.endsWith(',')) _commitInput();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────
        Row(
          children: [
            Text('Additional Features', style: tt.titleMedium),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.section,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                'Optional',
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'e.g., Premium legroom, USB-C ports, Curtains',
          style: tt.bodyMedium?.copyWith(
              color: AppColors.textHint, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Input Field ───────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onChanged,
                onSubmitted: (_) {
                  _commitInput();
                  _focusNode.requestFocus();
                },
                style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Premium legroom, USB-C ports, Curtains',
                  hintStyle:
                      tt.bodyMedium?.copyWith(color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.add_circle_outline_rounded,
                      size: 18, color: AppColors.textHint),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _AddButton(onTap: () {
              _commitInput();
              _focusNode.requestFocus();
            }),
          ],
        ),

        // ── Helper hint ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            'Separate features with a comma or press Add.',
            style: tt.bodyMedium
                ?.copyWith(color: AppColors.textHint, fontSize: 11),
          ),
        ),

        // ── Chips ─────────────────────────────────────────────────
        if (_features.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _features
                .map((f) => _FeatureChip(label: f, onRemove: () => _remove(f)))
                .toList(),
          ),
        ],
      ],
    );
  }
}

// ── Add Button ────────────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 1,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Add',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
        ),
      ),
    );
  }
}

// ── Feature Chip ──────────────────────────────────────────────────────────────

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label, required this.onRemove});
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.xs,
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tt.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  size: 12, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
