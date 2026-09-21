/// Shared interface for all bus seat layout widgets.
library;

import 'package:flutter/material.dart';

/// Full 7-state seat status used across all bus layouts.
enum SeatStatus {
  available,
  blocked,
  blockedMale,
  blockedFemale,
  permanentlyUnavailable,
  releasedForDate,
  booked;

  String get label => switch (this) {
        available => 'Available',
        blocked => 'Blocked',
        blockedMale => 'Blocked (Male)',
        blockedFemale => 'Blocked (Female)',
        permanentlyUnavailable => 'Permanently unavailable',
        releasedForDate => 'Released for this date',
        booked => 'Booked (locked)',
      };

  Color get fillColor => switch (this) {
        available => Colors.white,
        blocked => const Color(0xFF64748B),
        blockedMale => const Color(0xFF1D4ED8),
        blockedFemale => const Color(0xFFBE185D),
        permanentlyUnavailable => const Color(0xFF334155),
        releasedForDate => const Color(0xFFFEF08A),
        booked => const Color(0xFF1E3A8A),
      };

  Color get borderColor => switch (this) {
        available => const Color(0xFF2ECC71),
        releasedForDate => const Color(0xFFEAB308),
        _ => fillColor,
      };

  /// Whether the passenger/operator can tap this seat.
  bool get isClickable => switch (this) {
        available || releasedForDate => true,
        _ => false,
      };
}

/// Callback fired whenever the selection changes.
typedef OnSeatSelected = void Function(List<int> selectedSeats);
