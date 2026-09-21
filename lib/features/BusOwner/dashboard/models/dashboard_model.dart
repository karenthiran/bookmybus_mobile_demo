class DashboardMetricModel {
  final String title;
  final String value;
  final bool isAlert;
  final String badge;

  const DashboardMetricModel({
    required this.title,
    required this.value,
    this.isAlert = false,
    this.badge = 'No change vs prev',
  });
}

class DashboardRouteModel {
  final String route;
  final String meta;
  final String revenueTag;

  const DashboardRouteModel({
    required this.route,
    required this.meta,
    required this.revenueTag,
  });
}

class DashboardBusModel {
  final String busName;
  final String revenueTag;

  const DashboardBusModel({
    required this.busName,
    required this.revenueTag,
  });
}

class DashboardCancelledRouteModel {
  final String route;
  final String cancellationCount;

  const DashboardCancelledRouteModel({
    required this.route,
    required this.cancellationCount,
  });
}

class DashboardTrendModel {
  final List<int> values;
  final List<String> labels;
  final int peakIndex;

  const DashboardTrendModel({
    required this.values,
    required this.labels,
    required this.peakIndex,
  });
}
