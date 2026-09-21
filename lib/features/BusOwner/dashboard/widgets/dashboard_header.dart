import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.operatorName,
    required this.greeting,
    required this.totalRevenue,
    required this.onProfileTap,
  });

  final String operatorName;
  final String greeting;
  final String totalRevenue;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            MediaQuery.of(context).padding.top + AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxxl + 36,
          ),
          color: AppColors.primary,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.white.withOpacity(0.75),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      operatorName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -36,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          child: _RevenueCard(totalRevenue: totalRevenue),
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.totalRevenue});
  final String totalRevenue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL REVENUE',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  totalRevenue,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.section,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money,
                color: AppColors.primary, size: 24),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Pills ─────────────────────────────────────────────────────────────

class DashboardFilterPills extends StatelessWidget {
  const DashboardFilterPills({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (i) {
          final active = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : const Color(0xFFEEEFF5),
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: Text(
                filters[i],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          active ? AppColors.white : AppColors.textPrimary,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
