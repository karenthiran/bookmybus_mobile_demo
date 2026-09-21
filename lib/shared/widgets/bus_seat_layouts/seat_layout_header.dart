import 'package:flutter/material.dart';
import 'bus_seat_layout.dart';

/// Responsive header shown above every bus seat layout.
///
/// - Desktop (≥ 600 px): date info on the left, legend on the right.
/// - Mobile (< 600 px): stacked column.
class SeatLayoutHeader extends StatelessWidget {
  const SeatLayoutHeader({super.key, required this.viewingDate});

  /// ISO-formatted date string, e.g. "2026-08-21".
  final String viewingDate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isDesktop = constraints.maxWidth >= 600;
        return isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _DateInfo(viewingDate: viewingDate)),
                  const SizedBox(width: 24),
                  _Legend(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateInfo(viewingDate: viewingDate),
                  const SizedBox(height: 12),
                  _Legend(),
                ],
              );
      },
    );
  }
}

// ── Left section ──────────────────────────────────────────────────────────────

class _DateInfo extends StatelessWidget {
  const _DateInfo({required this.viewingDate});
  final String viewingDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            children: [
              const TextSpan(text: 'Viewing date: '),
              TextSpan(
                text: viewingDate,
                style: const TextStyle(color: Color(0xFF1E3A8A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Click a seat to toggle unavailable status. Booked and permanently blocked seats cannot be changed.',
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

// ── Right section — legend ────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: SeatStatus.values
          .map((s) => _LegendItem(status: s))
          .toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.status});
  final SeatStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: status.fillColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: status.borderColor, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          status.label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}
