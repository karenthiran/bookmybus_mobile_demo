import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../BusOwner/addbus/pages/edit_bus_page.dart';
import '../../../BusOwner/manage_seats/pages/manage_seat_page.dart';
import '../models/manage_bus_model.dart';
import 'bus_view_sheet.dart';

class BusFleetCard extends StatelessWidget {
  const BusFleetCard({super.key, required this.bus});

  final BusFleetModel bus;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        bus.busName,
                        style: tt.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusBadge(status: bus.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                // Approval + Bus Type pills
                Row(
                  children: [
                    _ApprovalBadge(status: bus.approvalStatus),
                    const SizedBox(width: AppSpacing.xs),
                    _Pill(label: bus.busType),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border),

          // ── Bus No. & Route ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Bus No.
                _LabelValue(label: 'Bus No.', value: bus.registrationNo),
                const SizedBox(width: AppSpacing.xxl),
                // Route
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Route',
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            bus.fromCity,
                            style: tt.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            bus.toCity,
                            style: tt.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border),

          // ── Stats Row ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                _StatCell(label: 'Departure', value: bus.departure),
                _VerticalDivider(),
                _StatCell(label: 'Arrival', value: bus.arrival),
                _VerticalDivider(),
                _StatCell(label: 'Price', value: bus.price),
                _VerticalDivider(),
                _StatCell(label: 'Seats', value: '${bus.totalSeats}'),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border),

          // ── Action Buttons ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _ActionButton(
                  label: 'View',
                  icon: Icons.visibility_outlined,
                  onTap: () => showBusViewSheet(context, bus),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditBusPage(bus: bus),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: 'Manage Seats',
                  icon: Icons.event_seat_outlined,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ManageSeatPage(bus: bus),
                    ),
                  ),
                  filled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Cell ─────────────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: tt.bodySmall?.copyWith(
              color: AppColors.textHint,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: tt.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Label / Value ─────────────────────────────────────────────────────────────

class _LabelValue extends StatelessWidget {
  const _LabelValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(color: AppColors.textHint, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Vertical Divider ──────────────────────────────────────────────────────────

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final BusStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      BusStatus.active => ('Active', AppColors.successLight, AppColors.success),
      BusStatus.inactive => ('Inactive', AppColors.errorLight, AppColors.error),
      BusStatus.maintenance => (
          'Maintenance',
          AppColors.warningLight,
          AppColors.warning,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
      ),
    );
  }
}

// ── Approval Badge ────────────────────────────────────────────────────────────

class _ApprovalBadge extends StatelessWidget {
  const _ApprovalBadge({required this.status});

  final BusApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      BusApprovalStatus.approved => (
          'approved',
          AppColors.section,
          AppColors.primary,
        ),
      BusApprovalStatus.pending => (
          'pending',
          AppColors.warningLight,
          AppColors.warning,
        ),
      BusApprovalStatus.rejected => (
          'rejected',
          AppColors.errorLight,
          AppColors.error,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Status: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fg,
                  fontSize: 10,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Generic Pill ──────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.primary : AppColors.section;
    final fg = filled ? AppColors.white : AppColors.primary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: filled ? null : Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
