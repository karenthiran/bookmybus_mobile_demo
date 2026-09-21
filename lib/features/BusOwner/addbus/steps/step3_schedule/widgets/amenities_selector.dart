import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'amenity_chip.dart';

class _Amenity {
  const _Amenity(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _amenities = [
  _Amenity('A/C', Icons.ac_unit_rounded),
  _Amenity('WiFi', Icons.wifi_rounded),
  _Amenity('Charging Ports', Icons.electrical_services_rounded),
  _Amenity('Reclining Seats', Icons.airline_seat_recline_extra_rounded),
  _Amenity('TV', Icons.tv_rounded),
  _Amenity('Music', Icons.music_note_rounded),
  _Amenity('Water Bottle', Icons.water_drop_rounded),
  _Amenity('Blanket', Icons.bed_rounded),
];

class AmenitiesSelector extends StatefulWidget {
  const AmenitiesSelector({
    super.key,
    this.onChanged,
  });

  /// Called with the updated list of selected amenity labels on every change.
  final ValueChanged<List<String>>? onChanged;

  @override
  State<AmenitiesSelector> createState() => _AmenitiesSelectorState();
}

class _AmenitiesSelectorState extends State<AmenitiesSelector> {
  final Set<String> _selected = {};

  void _toggle(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
    widget.onChanged?.call(_selected.toList());
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
            Text('Amenities', style: tt.titleMedium),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 2,
              ),
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
          'Select the amenities available on this bus.',
          style: tt.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Chips ─────────────────────────────────────────────────
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _amenities
              .map((a) => AmenityChip(
                    label: a.label,
                    icon: a.icon,
                    selected: _selected.contains(a.label),
                    onTap: () => _toggle(a.label),
                  ))
              .toList(),
        ),

        // ── Selected count hint ───────────────────────────────────
        if (_selected.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded,
                  size: 14, color: AppColors.success),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${_selected.length} amenit${_selected.length == 1 ? 'y' : 'ies'} selected',
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
