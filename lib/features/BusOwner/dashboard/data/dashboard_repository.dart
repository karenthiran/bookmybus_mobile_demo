import '../../../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

/// One filter -> `rangeType` query param understood by the backend
/// (see server/utils/dateRange.js: "today" | "last7" | "last30").
const List<String> dashboardFilters = ['Today', 'Last 7 days', 'Last 30 days'];

const List<String> _rangeTypes = ['today', 'last7', 'last30'];

/// Everything the dashboard screen needs, already mapped into the app's
/// existing UI models so the widgets don't need to change.
class DashboardData {
  const DashboardData({
    required this.metrics,
    required this.topRoutes,
    required this.topBuses,
    required this.cancelledRoutes,
    required this.bookingsTrend,
    required this.revenueTrend,
    required this.totalRevenueLabel,
  });

  final List<DashboardMetricModel> metrics;
  final List<DashboardRouteModel> topRoutes;
  final List<DashboardBusModel> topBuses;
  final List<DashboardCancelledRouteModel> cancelledRoutes;
  final DashboardTrendModel bookingsTrend;
  final DashboardTrendModel revenueTrend;
  final String totalRevenueLabel;
}

class DashboardRepository {
  /// [filterIndex] matches the index into [dashboardFilters].
  Future<DashboardData> fetchDashboard({int filterIndex = 0}) async {
    final rangeType = _rangeTypes[filterIndex.clamp(0, _rangeTypes.length - 1)];

    final json = await ApiClient.instance.get(
      '/companies/dashboard-stats',
      query: {'rangeType': rangeType},
    ) as Map<String, dynamic>;

    final kpis = (json['kpis'] as Map<String, dynamic>? ?? {});
    final charts = (json['charts'] as Map<String, dynamic>? ?? {});
    final insights = (json['insights'] as Map<String, dynamic>? ?? {});

    num _val(String key) =>
        ((kpis[key] as Map?)?['value'] as num?) ?? 0;
    num _delta(String key) =>
        ((kpis[key] as Map?)?['deltaPercent'] as num?) ?? 0;

    String _badge(num delta) {
      if (delta == 0) return 'No change vs prev';
      final sign = delta > 0 ? '+' : '';
      return '$sign${delta.toStringAsFixed(0)}% vs prev';
    }

    final revenueValue = _val('revenue');

    final metrics = <DashboardMetricModel>[
      DashboardMetricModel(
        title: 'TOTAL BUSES',
        value: _val('totalBuses').toStringAsFixed(0),
        badge: _badge(_delta('totalBuses')),
      ),
      DashboardMetricModel(
        title: 'BOOKINGS',
        value: _val('totalBookings').toStringAsFixed(0),
        badge: _badge(_delta('totalBookings')),
      ),
      DashboardMetricModel(
        title: 'REVENUE',
        value: _formatCurrency(revenueValue),
        badge: _badge(_delta('revenue')),
      ),
      DashboardMetricModel(
        title: 'CANCELLATIONS',
        value: _val('cancellations').toStringAsFixed(0),
        isAlert: _val('cancellations') > 0,
        badge: _badge(_delta('cancellations')),
      ),
      DashboardMetricModel(
        title: 'OCCUPANCY RATE',
        value: '${_val('occupancyRate').toStringAsFixed(1)}%',
        badge: _badge(_delta('occupancyRate')),
      ),
      DashboardMetricModel(
        title: 'TRIPS',
        value: _val('trips').toStringAsFixed(0),
        badge: _badge(_delta('trips')),
      ),
    ];

    final topRoutes = ((insights['topRoutes'] as List?) ?? [])
        .map((e) => DashboardRouteModel(
              route: (e['route'] ?? '').toString(),
              meta: '${e['bookings'] ?? 0} BOOKING${(e['bookings'] ?? 0) == 1 ? '' : 'S'}',
              revenueTag: _formatCurrency(e['revenue'] ?? 0),
            ))
        .toList();

    final topBuses = ((insights['topBuses'] as List?) ?? [])
        .map((e) => DashboardBusModel(
              busName: (e['busName'] ?? '').toString(),
              revenueTag: _formatCurrency(e['revenue'] ?? 0),
            ))
        .toList();

    final cancelledRoutes = ((insights['topCancelledRoutes'] as List?) ?? [])
        .map((e) => DashboardCancelledRouteModel(
              route: (e['route'] ?? '').toString(),
              cancellationCount:
                  '${e['cancellations'] ?? 0} CANCELLATION${(e['cancellations'] ?? 0) == 1 ? '' : 'S'}',
            ))
        .toList();

    DashboardTrendModel _trend(List? points, String countKey) {
      final list = points ?? const [];
      final values = list
          .map<int>((p) => ((p[countKey] as num?) ?? 0).round())
          .toList();
      final labels = list
          .map<String>((p) => _shortLabel((p['date'] ?? '').toString()))
          .toList();
      var peakIndex = 0;
      for (var i = 0; i < values.length; i++) {
        if (values[i] > (values.isEmpty ? 0 : values[peakIndex])) peakIndex = i;
      }
      return DashboardTrendModel(
        values: values.isEmpty ? const [0] : values,
        labels: labels.isEmpty ? const [''] : labels,
        peakIndex: peakIndex,
      );
    }

    return DashboardData(
      metrics: metrics,
      topRoutes: topRoutes,
      topBuses: topBuses,
      cancelledRoutes: cancelledRoutes,
      bookingsTrend: _trend(charts['bookingsTrend'] as List?, 'count'),
      revenueTrend: _trend(charts['revenueTrend'] as List?, 'amount'),
      totalRevenueLabel: _formatCurrency(revenueValue),
    );
  }

  String _formatCurrency(num value) {
    // Simple thousands separator, e.g. 25000 -> "Rs 25,000.00"
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0];
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      final posFromEnd = whole.length - i;
      buffer.write(whole[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return 'Rs $buffer.${parts[1]}';
  }

  /// "2026-01-05" -> "M" / "T" / etc (matches the dummy data's day-letter
  /// labels used by the trend chart widget).
  String _shortLabel(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return days[date.weekday - 1];
    } catch (_) {
      return '';
    }
  }
}
