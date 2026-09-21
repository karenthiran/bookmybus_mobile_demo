import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class FilterSummaryCard extends StatelessWidget {
  const FilterSummaryCard({
    super.key,
    this.viewLabel = 'All Buses',
    this.dateFrom = '2026-07-30',
    this.dateTo = '2026-07-30',
    this.dateNote = 'Today',
    this.totalBookings = 0,
    this.confirmed = 0,
    this.cancelled = 0,
    this.revenue = 0,
  });

  final String viewLabel;
  final String dateFrom;
  final String dateTo;
  final String dateNote;
  final int totalBookings;
  final int confirmed;
  final int cancelled;
  final num revenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
              children: [
                const TextSpan(text: 'Currently viewing: '),
                TextSpan(
                  text: viewLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'Range: '),
                TextSpan(text: '$dateFrom -> $dateTo'),
                if (dateNote.isNotEmpty) TextSpan(text: ' ($dateNote)'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Pill(label: 'Total: $totalBookings bookings', bg: const Color(0xFFF3F4F6), fg: AppColors.textPrimary),
              _Pill(label: 'Confirmed: $confirmed', bg: AppColors.successLight, fg: const Color(0xFF15803D), bold: true),
              _Pill(label: 'Cancelled: $cancelled', bg: AppColors.errorLight, fg: const Color(0xFFB91C1C), bold: true),
              _Pill(label: 'Revenue: LKR $revenue', bg: AppColors.infoLight, fg: const Color(0xFF1D4ED8), bold: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg, this.bold = false});

  final String label;
  final Color bg;
  final Color fg;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: fg, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
