import 'package:flutter/material.dart';
import 'bus_seat_layout.dart';

/// 2+2 — 45-seat interactive layout.
///
/// Rows 1–11 : 4 seats (2 left | aisle | 2 right)
/// Row  12   : 1 seat on the left only (45)
///
/// [seatStatuses] maps seat number → [SeatStatus].
/// Seats absent from the map are treated as [SeatStatus.available].
class TwoByTwo45SeatLayout extends StatefulWidget {
  const TwoByTwo45SeatLayout({
    super.key,
    this.seatStatuses = const {},
    this.selectedSeats = const {},
    this.callBookingSeats = const {},
    this.onSeatTapped,
    this.onSeatSelected,
  });

  final Map<int, SeatStatus> seatStatuses;
  final Set<int> selectedSeats;
  /// Maps seat number → (gender, phone) for call-booked seats.
  final Map<int, ({String gender, String phone})> callBookingSeats;
  final ValueChanged<int>? onSeatTapped;
  final OnSeatSelected? onSeatSelected;

  @override
  State<TwoByTwo45SeatLayout> createState() => _TwoByTwo45SeatLayoutState();
}

class _TwoByTwo45SeatLayoutState extends State<TwoByTwo45SeatLayout> {

  // Rows 1–10: [leftWindow, leftAisle, rightAisle, rightWindow]
  static const List<List<int>> _rows = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
    [21, 22, 23, 24],
    [25, 26, 27, 28],
    [29, 30, 31, 32],
    [33, 34, 35, 36],
    [37, 38, 39, 40],
  ];

  // Row 11: 5-seat back bench
  static const List<int> _backRow = [41, 42, 43, 44, 45];

  void _toggle(int seat) {
    final status = widget.seatStatuses[seat] ?? SeatStatus.available;
    if (!status.isClickable) return;

    widget.onSeatTapped?.call(seat);

    final next = Set<int>.from(widget.selectedSeats);
    if (next.contains(seat)) {
      next.remove(seat);
    } else {
      next.add(seat);
    }
    widget.onSeatSelected?.call(List.unmodifiable(next.toList()..sort()));
  }

  SeatStatus _effectiveStatus(int seat) =>
      widget.seatStatuses[seat] ?? SeatStatus.available;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._rows.asMap().entries.map((entry) {
              final seats = entry.value;
              return _SeatRow(
                rowNumber: entry.key + 1,
                left: [seats[0], seats[1]],
                right: [seats[2], seats[3]],
                effectiveStatus: _effectiveStatus,
                isSelected: widget.selectedSeats.contains,
                callBookingSeats: widget.callBookingSeats,
                onTap: _toggle,
              );
            }),
            const SizedBox(height: 8),
            _BackRow(
              rowNumber: 11,
              seats: _backRow,
              effectiveStatus: _effectiveStatus,
              isSelected: widget.selectedSeats.contains,
              callBookingSeats: widget.callBookingSeats,
              onTap: _toggle,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.rowNumber,
    required this.left,
    required this.right,
    required this.effectiveStatus,
    required this.isSelected,
    required this.callBookingSeats,
    required this.onTap,
  });

  final int rowNumber;
  final List<int> left;
  final List<int> right;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
  final Map<int, ({String gender, String phone})> callBookingSeats;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rowNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ...left.map((s) => _SeatCell(
                seat: s,
                status: effectiveStatus(s),
                isSelected: isSelected(s),
                callInfo: callBookingSeats[s],
                onTap: onTap,
              )),
          const SizedBox(width: 36),
          ...right.map((s) => _SeatCell(
                seat: s,
                status: effectiveStatus(s),
                isSelected: isSelected(s),
                callInfo: callBookingSeats[s],
                onTap: onTap,
              )),
        ],
      ),
    );
  }
}

class _BackRow extends StatelessWidget {
  const _BackRow({
    required this.rowNumber,
    required this.seats,
    required this.effectiveStatus,
    required this.isSelected,
    required this.callBookingSeats,
    required this.onTap,
  });

  final int rowNumber;
  final List<int> seats;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
  final Map<int, ({String gender, String phone})> callBookingSeats;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rowNumber',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ...seats.map((s) => _SeatCell(
                seat: s,
                status: effectiveStatus(s),
                isSelected: isSelected(s),
                callInfo: callBookingSeats[s],
                onTap: onTap,
              )),
        ],
      ),
    );
  }
}

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.seat,
    required this.status,
    required this.isSelected,
    required this.onTap,
    this.callInfo,
  });

  final int seat;
  final SeatStatus status;
  final bool isSelected;
  final void Function(int) onTap;
  final ({String gender, String phone})? callInfo;

  @override
  Widget build(BuildContext context) {
    // Call-booking seat: navy tile with gender, seat number, phone + 'C' badge
    if (callInfo != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      callInfo!.gender,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      '$seat',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      callInfo!.phone.length > 7
                          ? callInfo!.phone.substring(callInfo!.phone.length - 7)
                          : callInfo!.phone,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 7,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              // White 'C' badge
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'C',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bg = status.fillColor;
    final border = status.borderColor;
    final effectiveBg = isSelected ? border : bg;
    final textColor = effectiveBg.computeLuminance() > 0.4
        ? const Color(0xFF1E293B)
        : Colors.white;

    return GestureDetector(
      onTap: status.isClickable ? () => onTap(seat) : null,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          '$seat',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

