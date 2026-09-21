import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

// ─── Trend Chart Card ─────────────────────────────────────────────────────────

class DashboardTrendCard extends StatelessWidget {
  const DashboardTrendCard({
    super.key,
    required this.title,
    required this.trend,
  });

  final String title;
  final DashboardTrendModel trend;

  @override
  Widget build(BuildContext context) {
    final maxVal = trend.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  'Visual',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(trend.values.length, (i) {
                final isPeak = i == trend.peakIndex;
                final heightFraction = trend.values[i] / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: heightFraction,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPeak
                                    ? AppColors.primary
                                    : AppColors.chart3,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(AppRadius.xs),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          trend.labels[i],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.textHint,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Routes Card ──────────────────────────────────────────────────────────

class DashboardTopRoutesCard extends StatelessWidget {
  const DashboardTopRoutesCard({super.key, required this.routes});

  final List<DashboardRouteModel> routes;

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      title: 'Top Routes',
      icon: Icons.route,
      children: routes
          .map((r) => _RouteRow(label: r.route, meta: r.meta, tag: r.revenueTag))
          .toList(),
    );
  }
}

// ─── Top Buses Card ───────────────────────────────────────────────────────────

class DashboardTopBusesCard extends StatelessWidget {
  const DashboardTopBusesCard({super.key, required this.buses});

  final List<DashboardBusModel> buses;

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      title: 'Top Buses',
      icon: Icons.directions_bus,
      children: buses
          .map((b) => _RouteRow(label: b.busName, meta: '', tag: b.revenueTag))
          .toList(),
    );
  }
}

// ─── Most Cancelled Routes Card ───────────────────────────────────────────────

class DashboardCancelledRoutesCard extends StatelessWidget {
  const DashboardCancelledRoutesCard({super.key, required this.routes});

  final List<DashboardCancelledRouteModel> routes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md)),
            ),
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined,
                    color: AppColors.error, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Most Cancelled Routes',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: routes
                  .map((r) => _CancelledRow(
                      route: r.route, count: r.cancellationCount))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.label,
    required this.meta,
    required this.tag,
  });

  final String label, meta, tag;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (meta.isNotEmpty)
                  Text(
                    meta,
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Text(
              tag,
              style: tt.bodySmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledRow extends StatelessWidget {
  const _CancelledRow({required this.route, required this.count});
  final String route, count;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              route,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            count,
            style: tt.bodySmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
