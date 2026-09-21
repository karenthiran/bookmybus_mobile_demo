import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import 'dashboard_metric_card.dart';
import 'dashboard_header.dart';
import 'filter_summary_card.dart';

class DashboardOverviewSection extends StatelessWidget {
  const DashboardOverviewSection({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.filterLabel,
    required this.metrics,
    required this.onFilterSelected,
  });

  final List<String> filters;
  final int selectedFilter;
  final String filterLabel;
  final List<DashboardMetricModel> metrics;
  final ValueChanged<int> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardFilterPills(
          filters: filters,
          selectedIndex: selectedFilter,
          onSelect: onFilterSelected,
        ),
        const FilterSummaryCard(),
        DashboardMetricsGrid(metrics: metrics, subtitle: filterLabel),
      ],
    );
  }
}
