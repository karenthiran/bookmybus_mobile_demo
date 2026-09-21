import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({
    super.key,
    required this.metrics,
    required this.subtitle,
  });

  final List<DashboardMetricModel> metrics;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.6,
      children: metrics
          .map((m) => DashboardMetricCard(metric: m))
          .toList(),
    );
  }
}

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.metric,
  });

  final DashboardMetricModel metric;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric.title,
            style: tt.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            metric.value,
            style: tt.titleMedium?.copyWith(
              color: metric.isAlert ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              metric.badge,
              style: tt.bodySmall?.copyWith(
                color: const Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
