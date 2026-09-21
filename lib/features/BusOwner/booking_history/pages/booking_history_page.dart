import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../data/dummy_booking_history.dart';
import '../models/booking_history_model.dart';
import '../widgets/booking_cards.dart';
import '../widgets/booking_history_card.dart';
import '../widgets/bus_seat_layout_view.dart';
import '../widgets/header_section.dart';
import '../widgets/filter_summary_section.dart';
import '../widgets/booking_count_bar_section.dart';
import '../widgets/empty_state.dart';
import 'booking_details_page.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  // View Booking Card state
  String _viewBus = 'All Buses';
  DateTime _viewDate = DateTime(2026, 7, 21);

  // Booking Overview Card state
  String _overviewBus = 'All Buses';
  String _overviewRoute = 'All Routes';
  String _overviewStatus = 'All Bookings';
  DateTime _overviewDate = DateTime(2026, 7, 21);
  DateTime? _fromDate;
  DateTime? _toDate;

  List<BookingHistoryModel> _results = DummyBookingHistory.bookings;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtDisplay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  void _onView() {
    final filtered = _applyFilters(bus: _viewBus, date: _viewDate);
    setState(() => _results = filtered);
    BusSeatLayoutView.show(
      context,
      busNumber: _viewBus == 'All Buses' ? 'All Buses' : _viewBus,
      travelDate: _fmtDisplay(_viewDate),
      bookings: filtered,
    );
  }

  void _onOverviewFilterChanged() {
    setState(() => _results = _applyFilters(
          bus: _overviewBus,
          route: _overviewRoute,
          status: _overviewStatus,
          date: _overviewDate,
          from: _fromDate,
          to: _toDate,
        ));
  }

  void _onClearFilters() {
    setState(() {
      _overviewBus = 'All Buses';
      _overviewRoute = 'All Routes';
      _overviewStatus = 'All Bookings';
      _overviewDate = DateTime(2026, 7, 21);
      _fromDate = null;
      _toDate = null;
      _results = DummyBookingHistory.bookings;
    });
  }

  List<BookingHistoryModel> _applyFilters({
    String bus = 'All Buses',
    String route = 'All Routes',
    String status = 'All Bookings',
    DateTime? date,
    DateTime? from,
    DateTime? to,
  }) {
    return DummyBookingHistory.bookings.where((b) {
      if (bus != 'All Buses' && b.busNumber != bus) return false;
      if (route != 'All Routes' && b.route != route) return false;
      if (status == 'Confirmed Only' && b.status != 'confirmed') return false;
      if (status == 'Cancelled Only' && b.status != 'cancelled') return false;
      if (date != null) {
        final d = _fmtDisplay(date);
        if (b.travelDate != d) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Booking History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            const BookingHistoryHeaderSection(),
            const SizedBox(height: AppSpacing.lg),

            // 2. View Booking Card
            ViewBookingCard(
              selectedBus: _viewBus,
              selectedDate: _viewDate,
              onBusChanged: (v) => setState(() => _viewBus = v),
              onDateChanged: (v) => setState(() => _viewDate = v ?? _viewDate),
              onView: _onView,
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Booking Overview Card
            BookingOverviewCard(
              selectedBus: _overviewBus,
              selectedRoute: _overviewRoute,
              selectedStatus: _overviewStatus,
              selectedDate: _overviewDate,
              fromDate: _fromDate,
              toDate: _toDate,
              onBusChanged: (v) {
                setState(() => _overviewBus = v);
                _onOverviewFilterChanged();
              },
              onRouteChanged: (v) {
                setState(() => _overviewRoute = v);
                _onOverviewFilterChanged();
              },
              onStatusChanged: (v) {
                setState(() => _overviewStatus = v);
                _onOverviewFilterChanged();
              },
              onDateChanged: (v) {
                setState(() => _overviewDate = v ?? _overviewDate);
                _onOverviewFilterChanged();
              },
              onFromDateChanged: (v) {
                setState(() => _fromDate = v);
                _onOverviewFilterChanged();
              },
              onToDateChanged: (v) {
                setState(() => _toDate = v);
                _onOverviewFilterChanged();
              },
              onClearFilters: _onClearFilters,
            ),
            const SizedBox(height: AppSpacing.lg),

            // 4. Selected Filter Summary
            FilterSummarySection(
              bus: _overviewBus,
              route: _overviewRoute,
              status: _overviewStatus,
              date: _fmt(_overviewDate),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 5. Booking Count + Export
            BookingCountBarSection(
              count: _results.length,
              onExport: _results.isEmpty ? null : () {},
            ),
            
            const SizedBox(height: AppSpacing.lg),

            // 6. Booking History List
            if (_results.isEmpty)
              const BookingHistoryEmptyState()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (_, i) => BookingHistoryCard(
                  booking: _results[i],
                  onViewBooking: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetailsPage(booking: _results[i]),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
