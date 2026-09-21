import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/bus_route_model.dart';

enum BusCardVariant { upcoming, standard }

// ── Resolved variant ───────────────────────────────────────────────────────────

class _Resolved {
  const _Resolved({
    required this.variant,
    required this.departureDay,   // "Today" | "Tomorrow"
    required this.displayTime,    // e.g. "06:30 AM"
    required this.statusText,     // "Available" | "Next: Tomorrow"
  });
  final BusCardVariant variant;
  final String departureDay;
  final String displayTime;
  final String statusText;
}

// ── BusRouteCard ───────────────────────────────────────────────────────────────

class BusRouteCard extends StatelessWidget {
  const BusRouteCard({super.key, required this.route, this.onTap});

  final BusRouteModel route;
  final void Function(BusRouteModel)? onTap;

  /// Builds today's scheduled departure [DateTime] from [now].
  /// If that moment has already passed, the next run is tomorrow → [upcoming].
  /// If it is still in the future → [standard].
  static _Resolved _resolve(BusRouteModel route, DateTime now) {
    final todayDeparture = DateTime(
      now.year,
      now.month,
      now.day,
      route.departureHour,
      route.departureMinute,
    );

    final departed = !todayDeparture.isAfter(now); // true when bus has left

    final departureDay = departed ? 'Tomorrow' : 'Today';
    final variant =
        departed ? BusCardVariant.upcoming : BusCardVariant.standard;
    final statusText = departed ? 'Next: Tomorrow' : 'Available';

    // Format the scheduled time for display (12-hour clock)
    final h24 = route.departureHour;
    final min = route.departureMinute;
    final period = h24 < 12 ? 'AM' : 'PM';
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final displayTime =
        '${h12.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $period';

    return _Resolved(
      variant: variant,
      departureDay: departureDay,
      displayTime: displayTime,
      statusText: statusText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final resolved = _resolve(route, DateTime.now());
    final isUpcoming = resolved.variant == BusCardVariant.upcoming;

    return GestureDetector(
      onTap: onTap != null ? () => onTap!(route) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageHeader(route: route, resolved: resolved),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route title
                Text(
                  route.routeName,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Operator row
                Row(
                  children: [
                    const Icon(Icons.directions_bus,
                        color: Color(0xFFEF4444), size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      route.operatorName,
                      style: tt.bodyMedium?.copyWith(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusBadge(
                      label: resolved.statusText,
                      isUpcoming: isUpcoming,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // Departure row
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Color(0xFF3B82F6), size: 14),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Departs ',
                      style: tt.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    _DepartureTimeText(resolved: resolved, isUpcoming: isUpcoming),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// ── Image Header ───────────────────────────────────────────────────────────────

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.route, required this.resolved});

  final BusRouteModel route;
  final _Resolved resolved;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = resolved.variant == BusCardVariant.upcoming;

    return SizedBox(
      height: 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          route.imageUrl != null
              ? Image.network(route.imageUrl!, fit: BoxFit.cover)
              : Container(
                  color: const Color(0xFFCBD5E1),
                  child: const Icon(Icons.directions_bus,
                      size: 60, color: Color(0xFF94A3B8)),
                ),

          // Top-left: bus type (emerald green)
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: _OverlayBadge(
                label: route.busType, color: const Color(0xFF059669)),
          ),

          // Top-right: frequency (blue)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: _OverlayBadge(
                label: route.frequency, color: const Color(0xFF2563EB)),
          ),

          // Bottom amber banner — upcoming only
          if (isUpcoming)
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _UpcomingBanner(resolved: resolved),
            ),
        ],
      ),
    );
  }
}

// ── Overlay Badge ──────────────────────────────────────────────────────────────

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.round)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Upcoming Banner ────────────────────────────────────────────────────────────

class _UpcomingBanner extends StatelessWidget {
  const _UpcomingBanner({required this.resolved});
  final _Resolved resolved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
          color: const Color(0xFFF59E0B),
          borderRadius: BorderRadius.circular(AppRadius.round)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, color: Colors.white, size: 13),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Next departure: ${resolved.departureDay} at ${resolved.displayTime}',
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Status Badge ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isUpcoming});
  final String label;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    final bg = isUpcoming ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9);
    final fg = isUpcoming ? const Color(0xFFD97706) : AppColors.textSecondary;
    final borderColor =
        isUpcoming ? const Color(0xFFF59E0B) : Colors.transparent;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.round),
        border: Border.all(color: borderColor),
      ),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Departure Time Text ────────────────────────────────────────────────────────

class _DepartureTimeText extends StatelessWidget {
  const _DepartureTimeText(
      {required this.resolved, required this.isUpcoming});
  final _Resolved resolved;
  final bool isUpcoming;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    if (isUpcoming) {
      return Text(
        '${resolved.displayTime} (${resolved.departureDay})',
        style: tt.bodySmall?.copyWith(
            color: const Color(0xFFD97706), fontWeight: FontWeight.w600),
      );
    }

    return Row(
      children: [
        Text(resolved.displayTime,
            style: tt.bodySmall?.copyWith(
                color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        Text(' (${resolved.departureDay})',
            style: tt.bodySmall?.copyWith(
                color: const Color(0xFF059669), fontWeight: FontWeight.bold)),
      ],
    );
  }
}
