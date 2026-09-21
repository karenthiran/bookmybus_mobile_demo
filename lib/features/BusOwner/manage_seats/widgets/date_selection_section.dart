import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'seat_management_card.dart';
import 'mode_chip.dart';
import 'date_picker_field.dart';

enum DateMode { single, range }

/// Date selection section for choosing single day or date range.
class DateSelectionSection extends StatelessWidget {
  const DateSelectionSection({
    required this.dateMode,
    required this.selectedDate,
    required this.selectedDateRange,
    required this.onDateModeChanged,
    required this.onDatePicked,
    required this.onRangePicked,
    required this.onLoadSeats,
    required this.seatsLoaded,
    super.key,
  });

  final DateMode dateMode;
  final DateTime? selectedDate;
  final DateTimeRange? selectedDateRange;
  final ValueChanged<DateMode> onDateModeChanged;
  final VoidCallback onDatePicked;
  final VoidCallback onRangePicked;
  final VoidCallback onLoadSeats;
  final bool seatsLoaded;

  String _fmt(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return SeatManagementCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode toggle
          Row(
            children: [
              ModeChip(
                label: 'Single Day',
                selected: dateMode == DateMode.single,
                onTap: () => onDateModeChanged(DateMode.single),
              ),
              const SizedBox(width: AppSpacing.sm),
              ModeChip(
                label: 'Date Range',
                selected: dateMode == DateMode.range,
                onTap: () => onDateModeChanged(DateMode.range),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Date picker field
          Text(
            dateMode == DateMode.single ? 'Date' : 'Date Range',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          dateMode == DateMode.single
              ? DatePickerField(
                  value: selectedDate != null ? _fmt(selectedDate!) : '',
                  hint: 'MM/DD/YYYY',
                  onTap: onDatePicked,
                )
              : DatePickerField(
                  value: selectedDateRange != null
                      ? '${_fmt(selectedDateRange!.start)} – ${_fmt(selectedDateRange!.end)}'
                      : '',
                  hint: 'MM/DD/YYYY – MM/DD/YYYY',
                  onTap: onRangePicked,
                ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLoadSeats,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Load Seats',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (!seatsLoaded) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.section,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Select a date or date range and click "Load Seats" to begin managing availability.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
