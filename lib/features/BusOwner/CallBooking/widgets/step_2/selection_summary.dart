import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SelectionSummary extends StatelessWidget {
  const SelectionSummary({
    required this.selected,
    required this.seatGenders,
    required this.onGenderSelected,
    required this.onRemove,
  });

  final List<int> selected;
  final Map<int, String> seatGenders;
  final void Function(int, String) onGenderSelected;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selected.map((seat) {
          final gender = seatGenders[seat];
          final label = '#$seat $gender';

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => onRemove(seat),
                  child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
