import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LegendRow extends StatelessWidget {
  const LegendRow();

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'Available', color: Colors.white, border: const Color(0xFF2ECC71)),
      (label: 'Booked (M)', color: const Color(0xFF2563EB), border: const Color(0xFF2563EB)),
      (label: 'Booked (F)', color: const Color(0xFFFCE7F3), border: const Color(0xFFEC4899)),
      (label: 'Pending', color: const Color(0xFFFDE68A), border: const Color(0xFFEAB308)),
      (label: 'Unavailable', color: const Color(0xFFD1D5DB), border: const Color(0xFF6B7280)),
      (label: 'Selected', color: const Color(0xFF1D4ED8), border: const Color(0xFF1D4ED8)),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: item.border, width: 1.5),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
