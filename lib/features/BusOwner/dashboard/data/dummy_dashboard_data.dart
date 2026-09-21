import '../models/dashboard_model.dart';

class DummyDashboardData {
  DummyDashboardData._();

  static const filters = ['Today', 'Last 7 days', 'Last 30 days'];

  static const metrics = [
    DashboardMetricModel(title: 'TOTAL BUSES', value: '12'),
    DashboardMetricModel(title: 'BOOKINGS', value: '148'),
    DashboardMetricModel(title: 'REVENUE', value: 'Rs 25K'),
    DashboardMetricModel(title: 'CANCELLATIONS', value: '9', isAlert: true),
    DashboardMetricModel(title: 'OCCUPANCY RATE', value: '0.0%'),
    DashboardMetricModel(title: 'TRIPS', value: '0'),
  ];

  static const topRoutes = [
    DashboardRouteModel(
        route: 'Colombo → Kandy', meta: '1 BOOKING', revenueTag: 'LKR 4,000'),
    DashboardRouteModel(
        route: 'Galle → Colombo', meta: '3 BOOKINGS', revenueTag: 'LKR 9,000'),
    DashboardRouteModel(
        route: 'Kandy → Jaffna', meta: '2 BOOKINGS', revenueTag: 'LKR 7,500'),
  ];

  static const topBuses = [
    DashboardBusModel(busName: 'BATTIEXPRESS', revenueTag: 'LKR 12,000'),
    DashboardBusModel(busName: 'KANDY LINER', revenueTag: 'LKR 9,500'),
    DashboardBusModel(busName: 'GALLE RIDER', revenueTag: 'LKR 7,200'),
  ];

  static const cancelledRoutes = [
    DashboardCancelledRouteModel(
        route: 'Colombo → Matara', cancellationCount: '3 CANCELLATIONS'),
    DashboardCancelledRouteModel(
        route: 'Kandy → Colombo', cancellationCount: '2 CANCELLATIONS'),
  ];

  static const bookingsTrend = DashboardTrendModel(
    values: [3, 7, 5, 9, 6, 11, 8],
    labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    peakIndex: 5,
  );

  static const revenueTrend = DashboardTrendModel(
    values: [4, 6, 8, 5, 10, 7, 9],
    labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    peakIndex: 4,
  );
}
