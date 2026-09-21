import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../data/dummy_bus_route_data.dart';
import '../models/bus_route_model.dart';
import '../widgets/book_your_journey_card.dart';
import '../widgets/bus_filter_tabs.dart';
import '../widgets/bus_route_card.dart';
import '../widgets/bus_search_bar.dart';

class PassengerHomePage extends StatefulWidget {
  const PassengerHomePage({super.key, this.onRouteSelected});

  final void Function(BusRouteModel)? onRouteSelected;

  @override
  State<PassengerHomePage> createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  int _selectedFilter = 0;
  String _searchQuery = '';

  List<BusRouteModel> get _filteredRoutes {
    final filterLabel = BusFilterTabs.filters[_selectedFilter];
    return DummyBusRouteData.routes.where((r) {
      final matchesFilter =
          filterLabel == 'All' || r.busType == filterLabel;
      final matchesSearch = _searchQuery.isEmpty ||
          r.routeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.operatorName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookYourJourneyCard(),
            const SizedBox(height: AppSpacing.xl),

            BusSearchBar(
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            const SizedBox(height: AppSpacing.md),

            BusFilterTabs(
              selectedIndex: _selectedFilter,
              onSelected: (i) => setState(() => _selectedFilter = i),
            ),
            const SizedBox(height: AppSpacing.lg),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredRoutes.length,
              itemBuilder: (_, i) => BusRouteCard(
                route: _filteredRoutes[i],
                onTap: widget.onRouteSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
