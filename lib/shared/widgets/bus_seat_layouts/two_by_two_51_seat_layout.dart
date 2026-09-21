import 'package:flutter/material.dart';
import 'bus_seat_layout.dart';

/// 2+2 — 51-seat interactive layout.
///
/// Rows 1–11 : 4 seats (2 left | aisle | 2 right)
/// Row  12   : 2 seats on the left only (45, 46)
/// Row  13   : full-width 5-seat back bench (49, 50, 51, 48, 47)
///
/// [seatStatuses] maps seat number → [SeatStatus].
/// Seats absent from the map are treated as [SeatStatus.available].
class TwoByTwo51SeatLayout extends StatefulWidget {
  const TwoByTwo51SeatLayout({
    super.key,
    this.seatStatuses = const {},
    this.onSeatSelected,
  });

  final Map<int, SeatStatus> seatStatuses;
  final OnSeatSelected? onSeatSelected;

  @override
  State<TwoByTwo51SeatLayout> createState() => _TwoByTwo51SeatLayoutState();
}

class _TwoByTwo51SeatLayoutState extends State<TwoByTwo51SeatLayout> {
  final Set<int> _selected = {};

  // ── 51-seat numbering ────────────────────────────────────────────────────
  // Each inner list: [leftWindow, leftAisle, rightAisle, rightWindow]
  // Pattern: 3,4 | 2,1 — 7,8 | 6,5 — ...
  static const List<List<int?>> _rows = [
    [3, 4, 2, 1],
    [7, 8, 6, 5],
    [11, 12, 10, 9],
    [15, 16, 14, 13],
    [19, 20, 18, 17],
    [23, 24, 22, 21],
    [27, 28, 26, 25],
    [31, 32, 30, 29],
    [35, 36, 34, 33],
    [39, 40, 38, 37],
    [43, 44, 42, 41],
    [45, 46, null, null], // row 12 — left only
  ];

  static const List<int> _backRow = [49, 50, 51, 48, 47];

  void _toggle(int seat) {
    final status = widget.seatStatuses[seat] ?? SeatStatus.available;
    if (!status.isClickable) return;

    setState(() {
      _selected.contains(seat) ? _selected.remove(seat) : _selected.add(seat);
    });
    widget.onSeatSelected?.call(List.unmodifiable(_selected));
  }

  SeatStatus _effectiveStatus(int seat) {
    // A tapped seat that is currently selected shows as its blocked variant
    // based on what the parent has assigned, but we overlay a "selected" visual
    // by passing isSelected=true to _SeatCell separately.
    return widget.seatStatuses[seat] ?? SeatStatus.available;
  }

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
                isSelected: _selected.contains,
                onTap: _toggle,
              );
            }),

            const SizedBox(height: 8),

            _BackRow(
              rowNumber: 13,
              seats: _backRow,
              effectiveStatus: _effectiveStatus,
              isSelected: _selected.contains,
              onTap: _toggle,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row widget ────────────────────────────────────────────────────────────────

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.rowNumber,
    required this.left,
    required this.right,
    required this.effectiveStatus,
    required this.isSelected,
    required this.onTap,
  });

  final int rowNumber;
  final List<int?> left;
  final List<int?> right;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
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
          ...left.map((s) => s != null
              ? _SeatCell(
                  seat: s,
                  status: effectiveStatus(s),
                  isSelected: isSelected(s),
                  onTap: onTap,
                )
              : const _EmptyCell()),
          const SizedBox(width: 36),
          ...right.map((s) => s != null
              ? _SeatCell(
                  seat: s,
                  status: effectiveStatus(s),
                  isSelected: isSelected(s),
                  onTap: onTap,
                )
              : const _EmptyCell()),
        ],
      ),
    );
  }
}

// ── Back row widget ───────────────────────────────────────────────────────────

class _BackRow extends StatelessWidget {
  const _BackRow({
    required this.rowNumber,
    required this.seats,
    required this.effectiveStatus,
    required this.isSelected,
    required this.onTap,
  });

  final int rowNumber;
  final List<int> seats;
  final SeatStatus Function(int) effectiveStatus;
  final bool Function(int) isSelected;
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
                onTap: onTap,
              )),
        ],
      ),
    );
  }
}

// ── Individual seat cell ──────────────────────────────────────────────────────

class _SeatCell extends StatelessWidget {
  const _SeatCell({
    required this.seat,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final int seat;
  final SeatStatus status;
  final bool isSelected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Selected seats use the status fill color at full opacity with white text.
    final bg = status.fillColor;
    final border = status.borderColor;
    final clickable = status.isClickable;

    // When selected, darken the available/releasedForDate fill slightly
    // by using the border color as fill (it's already the accent color).
    final effectiveBg = isSelected ? border : bg;
    final textColor = _contrastText(effectiveBg);

    return GestureDetector(
      onTap: clickable ? () => onTap(seat) : null,
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

  /// Returns white or dark text depending on background luminance.
  Color _contrastText(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.4 ? const Color(0xFF1E293B) : Colors.white;
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell();

  @override
  Widget build(BuildContext context) =>
      const SizedBox(width: 50, height: 44); // 44 + 2×3 margin
}
