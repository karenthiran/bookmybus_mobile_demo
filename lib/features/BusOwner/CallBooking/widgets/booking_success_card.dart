import 'package:flutter/material.dart';

class BookingSuccessCard extends StatelessWidget {
  const BookingSuccessCard({
    super.key,
    required this.reference,
    required this.passengerName,
    required this.travelDate,
    required this.seats,
    required this.seatGenders,
    required this.totalAmount,
    required this.onCreateAnother,
  });

  final String reference;
  final String passengerName;
  final String travelDate;
  final List<int> seats;
  final Map<int, String> seatGenders;
  final double totalAmount;
  final VoidCallback onCreateAnother;

  String get _seatsLabel => seats
      .map((s) => 'S$s (${seatGenders[s] ?? '-'})')
      .join(', ');

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Booking Confirmed!',
            style: tt.titleLarge?.copyWith(
              color: const Color(0xFF1E3A8A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The booking has been created and an SMS sent to the customer.',
            style: tt.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // ── Receipt card ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _Row(label: 'Reference', value: reference, valueColor: const Color(0xFF2563EB)),
                _Row(label: 'Passenger', value: passengerName, bold: true),
                _Row(label: 'Travel Date', value: travelDate),
                _Row(label: 'Seats', value: _seatsLabel),
                _Row(
                  label: 'Total',
                  value: 'Rs ${totalAmount.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF16A34A),
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Footer action ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onCreateAnother,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Create Another Booking'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: const Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(
                color: valueColor ?? const Color(0xFF1E293B),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
