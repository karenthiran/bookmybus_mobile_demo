import 'package:bookmybus/shared/widgets/bus_seat_layouts/two_by_two_45_seat_layout.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/bus_seat_layouts/bus_seat_layout.dart';
import '../../../../shared/widgets/bus_seat_layouts/seat_layout_header.dart';
import '../../../../shared/widgets/bus_seat_layouts/two_by_two_51_seat_layout.dart';
import 'release_seats_dialog.dart';

enum _EditLevel { thisDate, permanent }

enum _GenderRestriction { none, male, female }

class SeatEditingWidget extends StatefulWidget {
  const SeatEditingWidget({super.key, required this.label});

  /// Human-readable label for the date or range being edited.
  final String label;

  @override
  State<SeatEditingWidget> createState() => _SeatEditingWidgetState();
}

class _SeatEditingWidgetState extends State<SeatEditingWidget> {
  _EditLevel _editLevel = _EditLevel.thisDate;
  _GenderRestriction _gender = _GenderRestriction.none;

  /// Seats the user has tapped in the layout (to block/restrict).
  List<int> _layoutSelected = [];

  /// Release window set via the Release dialog (permanent mode only).
  Set<int> _releasedSeats = {};
  DateTime? _releaseFrom;
  DateTime? _releaseTo;

  // ── Mock data ──────────────────────────────────────────────────────────────
  static const _bookedSeats = {3, 4, 7, 8, 11, 12};
  static const _permanentlyBlocked = {
    34, 15, 16, 19, 20, 23, 24, 27, 28, 32, 33, 35, 36, 39, 40, 41, 42, 43,
    44, 45, 14,
  };

  Map<int, SeatStatus> get _seatStatuses {
    final map = <int, SeatStatus>{};

    for (final s in _bookedSeats) {
      map[s] = SeatStatus.booked;
    }

    if (_editLevel == _EditLevel.permanent) {
      for (final s in _permanentlyBlocked) {
        map[s] = _releasedSeats.contains(s)
            ? SeatStatus.releasedForDate
            : SeatStatus.permanentlyUnavailable;
      }
    }

    // Seats the user has selected get the gender-appropriate blocked status.
    for (final s in _layoutSelected) {
      if (map[s] == null || map[s] == SeatStatus.available) {
        map[s] = switch (_gender) {
          _GenderRestriction.male => SeatStatus.blockedMale,
          _GenderRestriction.female => SeatStatus.blockedFemale,
          _GenderRestriction.none => SeatStatus.blocked,
        };
      }
    }

    return map;
  }

  Future<void> _openReleaseDialog() async {
    final result = await showReleaseSeatsDialog(context);
    if (result != null) {
      setState(() {
        _releasedSeats = Set<int>.from(result['seats'] as List);
        _releaseFrom = result['from'] as DateTime?;
        _releaseTo = result['to'] as DateTime?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.edit_calendar_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: 'Editing seats for: '),
                      TextSpan(
                        text: widget.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel(text: 'Edit Level'),
          const SizedBox(height: AppSpacing.sm),

          _SegmentedTabs(
            tabs: const ['This date / range', 'Permanent (all dates)'],
            selectedIndex: _editLevel.index,
            activeColor: AppColors.primary,
            onChanged: (i) => setState(() {
              _editLevel = _EditLevel.values[i];
              _layoutSelected = [];
            }),
          ),

          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel(text: 'Gender Restriction'),
          const SizedBox(height: AppSpacing.sm),

          _SegmentedTabs(
            tabs: const ['No Restriction', '♂ Male Only', '♀ Female Only'],
            selectedIndex: _gender.index,
            activeColor: _genderActiveColor,
            onChanged: (i) => setState(() {
              _gender = _GenderRestriction.values[i];
              _layoutSelected = [];
            }),
          ),

          if (_gender != _GenderRestriction.none) ...[
            const SizedBox(height: AppSpacing.sm),
            _GenderInfoChip(
              message: _gender == _GenderRestriction.male
                  ? 'Blocked seats will be reserved for male passengers only'
                  : 'Blocked seats will be reserved for female passengers only',
              bgColor: _gender == _GenderRestriction.male
                  ? const Color(0xFFE0F0FF)
                  : const Color(0xFFFFE6F2),
              textColor: _gender == _GenderRestriction.male
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFC2185B),
            ),
          ],

          if (_editLevel == _EditLevel.permanent) ...[
            const SizedBox(height: AppSpacing.lg),
            _ReleaseButton(onTap: _openReleaseDialog),
            if (_releasedSeats.isNotEmpty && _releaseFrom != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ReleaseInfoChip(
                seats: _releasedSeats,
                from: _releaseFrom!,
                to: _releaseTo!,
              ),
            ],
          ],

          // ── Seat Layout ──────────────────────────────────────────
          const SizedBox(height: AppSpacing.lg),
          const _SectionLabel(text: 'Seat Layout'),
          const SizedBox(height: AppSpacing.md),

          // Responsive header: date info + full 7-item legend
          SeatLayoutHeader(viewingDate: widget.label),

          const SizedBox(height: AppSpacing.md),
          // TwoByTwo51SeatLayout(
          //   seatStatuses: _seatStatuses,
          //   onSeatSelected: (seats) =>
          //       setState(() => _layoutSelected = seats),
          // ),

          TwoByTwo45SeatLayout(
  seatStatuses: _seatStatuses,
  onSeatSelected: (seats) => setState(() => _layoutSelected = seats),
),
          if (_layoutSelected.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _SelectedSeatsChip(seats: _layoutSelected, gender: _gender),
          ],
        ],
      ),
    );
  }

  Color get _genderActiveColor => switch (_gender) {
        _GenderRestriction.male => const Color(0xFF1976D2),
        _GenderRestriction.female => const Color(0xFFD81B60),
        _GenderRestriction.none => AppColors.primary,
      };
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.activeColor,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final Color activeColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(tabs.length, (i) {
        final selected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: selected ? activeColor : AppColors.section,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: selected ? activeColor : AppColors.border),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ReleaseButton extends StatelessWidget {
  const _ReleaseButton({required this.onTap});
  final VoidCallback onTap;

  static const _yellow = Color(0xFFB45309);
  static const _yellowBg = Color(0xFFFFFBEB);
  static const _yellowBorder = Color(0xFFFCD34D);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: _yellowBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _yellowBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔓', style: TextStyle(fontSize: 13)),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'Release for N Days',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _yellow),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Temporarily make permanently-blocked seats bookable for a date window.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ReleaseInfoChip extends StatelessWidget {
  const _ReleaseInfoChip(
      {required this.seats, required this.from, required this.to});

  final Set<int> seats;
  final DateTime from;
  final DateTime to;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Text(
        '🔓 ${seats.length} seat${seats.length == 1 ? '' : 's'} released '
        '${_fmt(from)} → ${_fmt(to)}',
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB45309)),
      ),
    );
  }
}

class _SelectedSeatsChip extends StatelessWidget {
  const _SelectedSeatsChip({required this.seats, required this.gender});
  final List<int> seats;
  final _GenderRestriction gender;

  @override
  Widget build(BuildContext context) {
    final genderLabel = switch (gender) {
      _GenderRestriction.male => ' · Male Only',
      _GenderRestriction.female => ' · Female Only',
      _GenderRestriction.none => '',
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${seats.length} seat${seats.length == 1 ? '' : 's'} selected'
        '$genderLabel: ${seats.join(', ')}',
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
    );
  }
}

class _GenderInfoChip extends StatelessWidget {
  const _GenderInfoChip({
    required this.message,
    required this.bgColor,
    required this.textColor,
  });

  final String message;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 15, color: textColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
