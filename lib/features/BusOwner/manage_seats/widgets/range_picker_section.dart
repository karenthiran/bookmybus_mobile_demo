import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'seat_management_card.dart';

/// Range date picker section with horizontally scrollable date chips.
class RangePickerSection extends StatelessWidget {
  const RangePickerSection({
    required this.selectedRange,
    required this.selectedRangeDate,
    required this.onDateSelected,
    super.key,
  });

  final DateTimeRange selectedRange;
  final DateTime? selectedRangeDate;
  final ValueChanged<DateTime> onDateSelected;

  String _fmtIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<DateTime> get _rangeDates {
    final dates = <DateTime>[];
    var cur = selectedRange.start;
    while (!cur.isAfter(selectedRange.end)) {
      dates.add(cur);
      cur = cur.add(const Duration(days: 1));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final dates = _rangeDates;
    return SeatManagementCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary header
          Row(
            children: [
              const Icon(
                Icons.date_range,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Selected range: ',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${_fmtIso(selectedRange.start)} → ${_fmtIso(selectedRange.end)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Horizontally scrollable date chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((d) {
                final selected = selectedRangeDate != null &&
                    d.year == selectedRangeDate!.year &&
                    d.month == selectedRangeDate!.month &&
                    d.day == selectedRangeDate!.day;
                // Mock counts – replace with real data
                const booked = 0;
                const blocked = 17;
                return GestureDetector(
                  onTap: () => onDateSelected(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.primary : AppColors.section,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fmtIso(d),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$booked booked, $blocked blocked',
                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? AppColors.white.withOpacity(0.85)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
