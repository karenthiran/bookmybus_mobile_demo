import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'analytics_filter_bottom_sheet.dart';

class DashboardNavigation extends StatelessWidget {
  const DashboardNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onSelected,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      elevation: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: 'Add Bus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus_outlined),
          activeIcon: Icon(Icons.directions_bus),
          label: 'Manage Buses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'Booking History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.headset_mic_outlined),
          activeIcon: Icon(Icons.headset_mic),
          label: 'Call Booking',
        ),
      ],
    );
  }
}

class DashboardFilterButton extends StatelessWidget {
  const DashboardFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 70,
      right: AppSpacing.lg,
      child: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const FilterBottomSheet(),
        ),
        child: const Icon(Icons.tune, color: AppColors.white),
      ),
    );
  }
}
