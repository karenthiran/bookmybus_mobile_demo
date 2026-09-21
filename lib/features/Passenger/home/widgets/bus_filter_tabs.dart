import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BusFilterTabs extends StatelessWidget {
  const BusFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const filters = ['All', 'Super Luxury', 'Luxury'];

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (i) {
          final active = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(filters[i]),
              selected: active,
              onSelected: (_) => onSelected(i),
              selectedColor: const Color(0xFF1E3A8A),
              backgroundColor: AppColors.white,
              labelStyle: TextStyle(
                color: active ? AppColors.white : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: active ? const Color(0xFF1E3A8A) : AppColors.border,
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
            ),
          );
        }),
      ),
    );
  }
}
