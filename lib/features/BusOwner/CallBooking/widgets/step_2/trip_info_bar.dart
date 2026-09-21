import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:flutter/material.dart';

class TripInfoBar extends StatelessWidget {
  const TripInfoBar({
    required this.busName,
    required this.from,
    required this.to,
    required this.departureTime,
  });

  final String busName;
  final String from;
  final String to;
  final String departureTime;

  @override
  Widget build(BuildContext context) {
    final text = '$busName · $from → $to · $departureTime';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: const Color(0xFF1D4ED8),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
