import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class RecentCallBookingEntry {
  final String ref;
  final String passengerName;
  final String passengerPhone;
  final String busName;
  final String date;
  final String departureTime;
  final int seatCount;
  final double amount;
  final String status;

  const RecentCallBookingEntry({
    required this.ref,
    required this.passengerName,
    required this.passengerPhone,
    required this.busName,
    required this.date,
    required this.departureTime,
    required this.seatCount,
    required this.amount,
    required this.status,
  });
}

// Dummy recent bookings — replace with real data source later
final _dummyRecent = [
  const RecentCallBookingEntry(
    ref: 'C5D94C49',
    passengerName: 'Ruwan Tharuka',
    passengerPhone: '0701002770',
    busName: 'TH EUEU',
    date: '2026-09-10',
    departureTime: '00:33',
    seatCount: 2,
    amount: 3000,
    status: 'Confirmed',
  ),
  const RecentCallBookingEntry(
    ref: '8E0B204A',
    passengerName: 'Sithija Tharuka',
    passengerPhone: 'zzz',
    busName: 'LION SUPER LINE',
    date: '2026-09-08',
    departureTime: '10:40',
    seatCount: 1,
    amount: 1850,
    status: 'Confirmed',
  ),
];

class RecentCallBookingsSheet extends StatelessWidget {
  const RecentCallBookingsSheet({super.key, this.entries});

  final List<RecentCallBookingEntry>? entries;

  static void show(BuildContext context, {List<RecentCallBookingEntry>? entries}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecentCallBookingsSheet(entries: entries),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = entries ?? _dummyRecent;
    final tt = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Recent Call Bookings',
                    style: tt.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1, color: AppColors.divider),

            // Table
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TableHeader(),
                        const Divider(height: 1, color: AppColors.divider),
                        ...data.map((e) => _TableRow(entry: e)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final style = tt.bodySmall?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w600,
    );
    return Container(
      color: AppColors.section,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          _Cell('Ref', 90, style),
          _Cell('Passenger', 150, style),
          _Cell('Bus', 140, style),
          _Cell('Date', 100, style),
          _Cell('Departure', 90, style),
          _Cell('Seats', 80, style),
          _Cell('Amount', 100, style),
          _Cell('Status', 90, style),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.entry});
  final RecentCallBookingEntry entry;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final baseStyle = tt.bodySmall?.copyWith(color: AppColors.textPrimary);

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ref
          SizedBox(
            width: 90,
            child: Text(
              entry.ref,
              style: tt.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),

          // Passenger
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.passengerName, style: baseStyle?.copyWith(fontWeight: FontWeight.w600)),
                Text(entry.passengerPhone, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),

          // Bus
          SizedBox(
            width: 140,
            child: Text(entry.busName, style: baseStyle),
          ),

          // Date
          SizedBox(
            width: 100,
            child: Text(entry.date, style: baseStyle),
          ),

          // Departure
          SizedBox(
            width: 90,
            child: Row(
              children: [
                const Text('🕐 ', style: TextStyle(fontSize: 12)),
                Text(entry.departureTime, style: baseStyle),
              ],
            ),
          ),

          // Seats
          SizedBox(
            width: 80,
            child: Text('${entry.seatCount} seat(s)', style: baseStyle),
          ),

          // Amount
          SizedBox(
            width: 100,
            child: Text(
              'LKR ${entry.amount.toStringAsFixed(0)}',
              style: baseStyle?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // Status
          SizedBox(
            width: 90,
            child: _StatusBadge(entry.status),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);
  final String status;

  @override
  Widget build(BuildContext context) {
    final isConfirmed = status.toLowerCase() == 'confirmed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: isConfirmed ? AppColors.successLight : AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isConfirmed ? AppColors.success : AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, this.width, this.style);
  final String text;
  final double width;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(text, style: style),
      ),
    );
  }
}
