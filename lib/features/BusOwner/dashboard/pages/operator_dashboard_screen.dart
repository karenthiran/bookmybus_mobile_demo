import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/Profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/session/app_session.dart';
import '../../CallBooking/pages/call_booking_page.dart';
import '../../addbus/pages/add_bus_page.dart';
import '../../booking_history/pages/booking_history_page.dart';
import '../../manage_bus/pages/manage_bus_page.dart';
import '../data/dashboard_repository.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_analytics_section.dart';
import '../widgets/dashboard_navigation.dart';
import '../widgets/dashboard_overview_section.dart';
import '../widgets/dashboard_top_lists_section.dart';

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  final _repository = DashboardRepository();

  int _selectedFilter = 0;
  int _selectedNav = 0;

  late Future<DashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _repository.fetchDashboard(filterIndex: _selectedFilter);
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilter = index;
      _dashboardFuture = _repository.fetchDashboard(filterIndex: index);
    });
  }

  Future<void> _refresh() async {
    final future = _repository.fetchDashboard(filterIndex: _selectedFilter);
    setState(() => _dashboardFuture = future);
    await future;
  }

  Widget _buildDashboardTab() {
    final operatorName = context.watch<AppSession>().company?.companyName ??
        'Bus Operator';
    final filterLabel = dashboardFilters[_selectedFilter];

    return Stack(
      children: [
        FutureBuilder<DashboardData>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final message = snapshot.error is ApiException
                  ? (snapshot.error as ApiException).message
                  : 'Could not load your dashboard. Pull down to retry.';
              return _DashboardError(message: message, onRetry: _refresh);
            }

            final data = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: DashboardHeader(
                      greeting: 'Good Morning 👋',
                      operatorName: operatorName,
                      totalRevenue: data.totalRevenueLabel,
                      onProfileTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ProfilePage()),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 36 + AppSpacing.lg),
                          DashboardOverviewSection(
                            filters: dashboardFilters,
                            selectedFilter: _selectedFilter,
                            filterLabel: filterLabel,
                            metrics: data.metrics,
                            onFilterSelected: _onFilterSelected,
                          ),
                          DashboardAnalyticsSection(
                            bookingsTrend: data.bookingsTrend,
                            revenueTrend: data.revenueTrend,
                          ),
                          DashboardTopListsSection(
                            topRoutes: data.topRoutes,
                            topBuses: data.topBuses,
                            cancelledRoutes: data.cancelledRoutes,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const DashboardFilterButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: IndexedStack(
        index: _selectedNav,
        children: [
          _buildDashboardTab(),
          const AddBusPage(),
          const ManageBusPage(),
          const BookingHistoryPage(),
          const CallBookingPage(),
        ],
      ),
      bottomNavigationBar: DashboardNavigation(
        selectedIndex: _selectedNav,
        onSelected: (i) => setState(() => _selectedNav = i),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined,
                        size: 40, color: AppColors.textHint),
                    const SizedBox(height: AppSpacing.md),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
