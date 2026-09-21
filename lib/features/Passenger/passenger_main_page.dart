import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/features/Passenger/booking_history/pages/passenger_booking_history_page.dart';
import 'package:bookmybus/features/Passenger/home/models/bus_route_model.dart';
import 'package:bookmybus/features/Passenger/home/pages/passenger_home_page.dart';
import 'package:bookmybus/features/Passenger/journey/pages/journey_page.dart';
import 'package:flutter/material.dart';

class PassengerMainPage extends StatefulWidget {
  const PassengerMainPage({super.key});

  @override
  State<PassengerMainPage> createState() => _PassengerMainPageState();
}

class _PassengerMainPageState extends State<PassengerMainPage> {
  int _currentIndex = 0;
  BusRouteModel? _selectedRoute;

  void _navigateToJourney(BusRouteModel route) {
    setState(() {
      _selectedRoute = route;
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PassengerHomePage(onRouteSelected: _navigateToJourney),
      JourneyPage(route: _selectedRoute),
      const PassengerBookingHistoryPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus_outlined), activeIcon: Icon(Icons.directions_bus), label: 'Journey'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Booking History'),
        ],
      ),
    );
  }
}
