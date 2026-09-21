import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/booking_history_model.dart';

class BusSeatLayoutView extends StatefulWidget {
  const BusSeatLayoutView({
    super.key,
    required this.busNumber,
    required this.travelDate,
    required this.bookings,
  });

  final String busNumber;
  final String travelDate;
  final List<BookingHistoryModel> bookings;

  static void show(
    BuildContext context, {
    required String busNumber,
    required String travelDate,
    required List<BookingHistoryModel> bookings,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BusSeatLayoutView(
        busNumber: busNumber,
        travelDate: travelDate,
        bookings: bookings,
      ),
    );
  }

  @override
  State<BusSeatLayoutView> createState() => _BusSeatLayoutViewState();
}

class _BusSeatLayoutViewState extends State<BusSeatLayoutView> {
  int? _selectedSeat;

  // Aggregate booked seats: seatNum → (gender, phone, isCall, passengerName)
  Map<int, ({String gender, String phone, bool isCall, String name})> get _bookedSeats {
    final map = <int, ({String gender, String phone, bool isCall, String name})>{};
    for (final booking in widget.bookings) {
      for (final s in booking.seats) {
        final match = RegExp(r'(\d+)\s*\((Male|Female)\)', caseSensitive: false)
            .firstMatch(s);
        if (match != null) {
          map[int.parse(match.group(1)!)] = (
            gender: match.group(2)!.toLowerCase() == 'male' ? 'M' : 'F',
            phone: booking.passengerPhone,
            isCall: booking.isCallBooking,
            name: booking.passengerName,
          );
        }
      }
    }
    return map;
  }

  String get _busLabel {
    if (widget.bookings.isNotEmpty) {
      return '${widget.bookings.first.busName.toUpperCase()} (${widget.busNumber})';
    }
    return widget.busNumber;
  }

  String get _routeLabel {
    if (widget.bookings.isNotEmpty) {
      return '${widget.bookings.first.from} → ${widget.bookings.first.to}';
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final booked = _bookedSeats;
    const totalSeats = 45;
    final bookedCount = booked.length;
    final availableCount = totalSeats - bookedCount;
    final maleCount = booked.values.where((v) => v.gender == 'M').length;
    final femaleCount = booked.values.where((v) => v.gender == 'F').length;
    final selectedInfo = _selectedSeat != null ? booked[_selectedSeat!] : null;

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              busLabel: _busLabel,
              routeLabel: _routeLabel,
              travelDate: widget.travelDate,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryChips(
                      total: totalSeats,
                      booked: bookedCount,
                      available: availableCount,
                      male: maleCount,
                      female: femaleCount,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _Legend(),
                    const SizedBox(height: AppSpacing.lg),
                    _SeatGrid(
                      bookedSeats: booked,
                      selectedSeat: _selectedSeat,
                      onSeatTapped: (seatNum) => setState(() {
                        _selectedSeat = _selectedSeat == seatNum ? null : seatNum;
                      }),
                    ),
                    if (selectedInfo != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      SeatDetailCardWidget(
                        seatNumber: _selectedSeat!,
                        passengerName: selectedInfo.name,
                        gender: selectedInfo.gender,
                        phone: selectedInfo.phone,
                        isCallBooking: selectedInfo.isCall,
                        onDismiss: () => setState(() => _selectedSeat = null),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.busLabel,
    required this.routeLabel,
    required this.travelDate,
  });

  final String busLabel;
  final String routeLabel;
  final String travelDate;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  busLabel,
                  style: tt.titleMedium
                      ?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  routeLabel,
                  style: tt.bodySmall?.copyWith(color: AppColors.white.withOpacity(0.85)),
                ),
                Text(
                  travelDate,
                  style: tt.bodySmall?.copyWith(color: AppColors.white.withOpacity(0.85)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Chips ────────────────────────────────────────────────────────────

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({
    required this.total,
    required this.booked,
    required this.available,
    required this.male,
    required this.female,
  });

  final int total, booked, available, male, female;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _Chip('Total Seats: $total', const Color(0xFFEEEEEE), AppColors.textPrimary),
        _Chip('Booked: $booked', const Color(0xFFDCEEFD), const Color(0xFF1565C0)),
        _Chip('Available: $available', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
        _Chip('Male: $male', AppColors.primary, AppColors.white),
        _Chip('Female: $female', const Color(0xFFFF4081), AppColors.white),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.bg, this.fg);
  final String label;
  final Color bg, fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _LegendItem(
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border, width: 1.5),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
          label: 'Available',
          tt: tt,
        ),
        _LegendItem(
          child: _SeatBox(label: 'M', bg: AppColors.primary, fg: AppColors.white, size: 22),
          label: 'Male',
          tt: tt,
        ),
        _LegendItem(
          child: _SeatBox(label: 'F', bg: const Color(0xFFFF4081), fg: AppColors.white, size: 22),
          label: 'Female',
          tt: tt,
        ),
        _LegendItem(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text('C',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('C',
                      style: TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 5,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          label: 'Call Booking',
          tt: tt,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.child, required this.label, required this.tt});
  final Widget child;
  final String label;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Seat Grid ────────────────────────────────────────────────────────────────

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.bookedSeats,
    required this.selectedSeat,
    required this.onSeatTapped,
  });
  final Map<int, ({String gender, String phone, bool isCall, String name})> bookedSeats;
  final int? selectedSeat;
  final ValueChanged<int> onSeatTapped;

  // Seat numbering: rows 1-10 → seats 1-40 (left: odd cols, right: even cols)
  // Row r, col c (0-indexed): seat = (r * 4) + c + 1
  // Back row: seats 41-45
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // FRONT label
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.section,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text('FRONT',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Rows 1–10
        ...List.generate(10, (r) {
          final rowNum = r + 1;
          final seats = List.generate(4, (c) => (r * 4) + c + 1);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    '$rowNum',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textHint),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                _SeatWidget(seatNum: seats[0], bookedSeats: bookedSeats, selectedSeat: selectedSeat, onTapped: onSeatTapped),
                const SizedBox(width: AppSpacing.xs),
                _SeatWidget(seatNum: seats[1], bookedSeats: bookedSeats, selectedSeat: selectedSeat, onTapped: onSeatTapped),
                // Aisle
                const Spacer(),
                _SeatWidget(seatNum: seats[2], bookedSeats: bookedSeats, selectedSeat: selectedSeat, onTapped: onSeatTapped),
                const SizedBox(width: AppSpacing.xs),
                _SeatWidget(seatNum: seats[3], bookedSeats: bookedSeats, selectedSeat: selectedSeat, onTapped: onSeatTapped),
              ],
            ),
          );
        }),
        // Back row (row 11) — 5 seats
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '11',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textHint),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              ...List.generate(5, (i) {
                final seatNum = 41 + i;
                return Padding(
                  padding: EdgeInsets.only(right: i < 4 ? AppSpacing.xs : 0),
                  child: _SeatWidget(seatNum: seatNum, bookedSeats: bookedSeats, selectedSeat: selectedSeat, onTapped: onSeatTapped),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SeatWidget extends StatelessWidget {
  const _SeatWidget({
    required this.seatNum,
    required this.bookedSeats,
    required this.selectedSeat,
    required this.onTapped,
  });
  final int seatNum;
  final Map<int, ({String gender, String phone, bool isCall, String name})> bookedSeats;
  final int? selectedSeat;
  final ValueChanged<int> onTapped;

  @override
  Widget build(BuildContext context) {
    final info = bookedSeats[seatNum];
    final isBooked = info != null;
    final isSelected = selectedSeat == seatNum;

    if (isBooked && info.isCall) {
      return GestureDetector(
        onTap: () => onTapped(seatNum),
        child: _CallBookingSeat(
          seatNum: seatNum,
          gender: info.gender,
          phone: info.phone,
          isSelected: isSelected,
        ),
      );
    }

    final isFemale = info?.gender == 'F';
    Color bg = isBooked
        ? (isFemale ? const Color(0xFFFF4081) : AppColors.primary)
        : AppColors.white;
    if (isSelected) bg = bg.withOpacity(0.65);
    final fg = isBooked ? AppColors.white : AppColors.textHint;
    final borderColor = isSelected
        ? const Color(0xFFFBBF24)
        : (isBooked ? Colors.transparent : AppColors.border);

    return GestureDetector(
      onTap: isBooked ? () => onTapped(seatNum) : null,
      child: _SeatBox(
        label: isBooked ? info!.gender : '$seatNum',
        bg: bg,
        fg: fg,
        borderColor: borderColor,
        size: 36,
        subLabel: isBooked ? '$seatNum' : null,
      ),
    );
  }
}

class _CallBookingSeat extends StatelessWidget {
  const _CallBookingSeat({
    required this.seatNum,
    required this.gender,
    required this.phone,
    this.isSelected = false,
  });

  final int seatNum;
  final String gender;
  final String phone;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(6),
              border: isSelected
                  ? Border.all(color: const Color(0xFFFBBF24), width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gender,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                Text(
                  '$seatNum',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                Text(
                  phone.length > 7 ? phone.substring(phone.length - 7) : phone,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 6,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          // 'C' badge
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 13,
              height: 13,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'C',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatBox extends StatelessWidget {
  const _SeatBox({
    required this.label,
    required this.bg,
    required this.fg,
    this.borderColor = Colors.transparent,
    required this.size,
    this.subLabel,
  });

  final String label;
  final Color bg, fg;
  final Color borderColor;
  final double size;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: subLabel != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: TextStyle(
                        color: fg,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.1)),
                Text(subLabel!,
                    style: TextStyle(color: fg, fontSize: 8, height: 1.1)),
              ],
            )
          : Center(
              child: Text(label,
                  style: TextStyle(
                      color: fg,
                      fontSize: size > 24 ? 11 : 10,
                      fontWeight: FontWeight.w600)),
            ),
    );
  }
}

// ─── Seat Detail Card ─────────────────────────────────────────────────────────

class SeatDetailCardWidget extends StatelessWidget {
  const SeatDetailCardWidget({
    super.key,
    required this.seatNumber,
    required this.passengerName,
    required this.gender,
    required this.phone,
    required this.isCallBooking,
    required this.onDismiss,
  });

  final int seatNumber;
  final String passengerName;
  final String gender;
  final String phone;
  final bool isCallBooking;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isFemale = gender == 'F';
    final genderLabel = isFemale ? 'Female' : 'Male';
    final genderColor =
        isFemale ? const Color(0xFFDB2777) : const Color(0xFF2563EB);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seat $seatNumber Details',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Text(
                  'Dismiss',
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // 2×2 grid
          Row(
            children: [
              Expanded(
                child: _DetailField(
                  label: 'Passenger',
                  value: passengerName,
                ),
              ),
              Expanded(
                child: _DetailField(
                  label: 'Gender',
                  value: genderLabel,
                  valueColor: genderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DetailField(
                  label: 'Contact',
                  value: phone,
                ),
              ),
              Expanded(
                child: _DetailField(
                  label: 'Booking Type',
                  value: isCallBooking ? 'Call Booking' : 'Online',
                  valueColor:
                      isCallBooking ? const Color(0xFFD97706) : AppColors.textPrimary,
                  icon: isCallBooking ? Icons.phone_in_talk_outlined : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = valueColor ?? AppColors.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(color: AppColors.textHint, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 3),
            ],
            Flexible(
              child: Text(
                value,
                style: tt.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text('Export PDF'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
