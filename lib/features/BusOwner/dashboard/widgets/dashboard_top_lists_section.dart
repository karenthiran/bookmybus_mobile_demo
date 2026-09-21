import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import 'dashboard_list_cards.dart';

class DashboardTopListsSection extends StatelessWidget {
  const DashboardTopListsSection({
    super.key,
    required this.topRoutes,
    required this.topBuses,
    required this.cancelledRoutes,
  });

  final List<DashboardRouteModel> topRoutes;
  final List<DashboardBusModel> topBuses;
  final List<DashboardCancelledRouteModel> cancelledRoutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        DashboardTopRoutesCard(routes: topRoutes),
        const SizedBox(height: AppSpacing.md),
        DashboardTopBusesCard(buses: topBuses),
        const SizedBox(height: AppSpacing.md),
        DashboardCancelledRoutesCard(routes: cancelledRoutes),
        const SizedBox(height: 100),
      ],
    );
  }
}
