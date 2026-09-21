import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class FilterSummarySection extends StatelessWidget {
  const FilterSummarySection({
    super.key,
    required this.bus,
    required this.route,
    required this.status,
    required this.date,
  });

  final String bus;
  final String route;
  final String status;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Text(
              'Selected Filters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(label: 'Bus', value: bus),
                _SummaryRow(label: 'Route', value: route),
                _SummaryRow(label: 'Status', value: status),
                _SummaryRow(label: 'Date', value: date),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: AppSpacing.sm, top: 1),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            '$label: ',
            style: tt.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(value, style: tt.bodyMedium),
        ],
      ),
    );
  }
}
