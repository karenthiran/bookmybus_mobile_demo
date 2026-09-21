import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import 'dashboard_list_cards.dart';

class DashboardAnalyticsSection extends StatelessWidget {
  const DashboardAnalyticsSection({
    super.key,
    required this.bookingsTrend,
    required this.revenueTrend,
  });

  final DashboardTrendModel bookingsTrend;
  final DashboardTrendModel revenueTrend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        DashboardTrendCard(title: 'Bookings Trend', trend: bookingsTrend),
        const SizedBox(height: AppSpacing.md),
        DashboardTrendCard(title: 'Revenue Trend', trend: revenueTrend),
      ],
    );
  }
}
