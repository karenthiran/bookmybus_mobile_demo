import 'dart:async';
import 'package:flutter/material.dart';

class SeatHoldCountdownBanner extends StatefulWidget {
  const SeatHoldCountdownBanner({
    super.key,
    this.durationSeconds = 600,
    required this.onTimerExpired,
  });

  final int durationSeconds;
  final VoidCallback onTimerExpired;

  @override
  State<SeatHoldCountdownBanner> createState() => _SeatHoldCountdownBannerState();
}

class _SeatHoldCountdownBannerState extends State<SeatHoldCountdownBanner> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.durationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        setState(() => _remaining = 0);
        widget.onTimerExpired();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final m = _remaining ~/ 60;
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == 0) return const SizedBox.shrink();

    final isUrgent = _remaining <= 50;

    final bg    = isUrgent ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB);
    final border = isUrgent ? const Color(0xFFFCA5A5) : const Color(0xFFFDE68A);
    final fg    = isUrgent ? const Color(0xFFDC2626) : const Color(0xFFC2410C);

    final label = isUrgent
        ? 'Seats held for $_formatted — complete booking soon!'
        : 'Seats held for $_formatted';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_clock_outlined, size: 18, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 13,
                fontWeight: isUrgent ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
