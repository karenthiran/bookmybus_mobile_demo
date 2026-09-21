import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/manage_bus_model.dart';

void showBusViewSheet(BuildContext context, BusFleetModel bus) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BusViewSheet(bus: bus),
  );
}

class _BusViewSheet extends StatelessWidget {
  const _BusViewSheet({required this.bus});
  final BusFleetModel bus;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenH * 0.92),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),

          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bus Details',
                        style: tt.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Quick overview of the selected bus details',
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.textHint, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border),

          // ── Scrollable Content ────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bus Details Card ──────────────────────────────
                  _SectionCard(
                    children: [
                      _DetailRow(label: 'Bus Name', value: bus.busName),
                      _DetailRow(label: 'Bus No', value: bus.registrationNo),
                      _DetailRow(label: 'Type', value: bus.busType),
                      _DetailRow(label: 'Frequency', value: bus.frequency),
                      _DetailRow(
                        label: 'Route',
                        value: '${bus.fromCity} → ${bus.toCity}',
                      ),
                      _DetailRow(label: 'Departure', value: bus.departure),
                      _DetailRow(label: 'Arrival', value: bus.arrival),
                      _DetailRow(
                          label: 'Seats', value: '${bus.totalSeats}'),
                      if (bus.seatLayout.isNotEmpty)
                        _DetailRow(
                            label: 'Seat Layout', value: bus.seatLayout),
                      _DetailRow(label: 'Price', value: bus.price),
                      _DetailRow(
                        label: 'Status',
                        value: bus.approvalStatus.name,
                      ),
                      _DetailRow(
                        label: 'Active',
                        value: bus.status == BusStatus.active ? 'Yes' : 'No',
                      ),
                      if (bus.amenities.isNotEmpty)
                        _DetailRow(
                          label: 'Amenities',
                          value: bus.amenities.join(', '),
                        ),
                      _ImageRow(imageUrl: bus.imageUrl),
                    ],
                  ),

                  if (bus.pickups.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Pickups',
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _SectionCard(
                      padding: EdgeInsets.zero,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bus.pickups.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: AppColors.border),
                          itemBuilder: (_, i) {
                            final stop = bus.pickups[i];
                            final isFirst = i == 0;
                            final isLast = i == bus.pickups.length - 1;
                            final dotColor = isFirst || isLast
                                ? AppColors.primary
                                : AppColors.border;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      stop.city,
                                      style: tt.bodySmall?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: isFirst || isLast
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    stop.time,
                                    style: tt.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children, this.padding});
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image Row ─────────────────────────────────────────────────────────────────

class _ImageRow extends StatelessWidget {
  const _ImageRow({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            'Image',
            style: tt.bodySmall
                ?.copyWith(color: AppColors.textHint, fontSize: 12),
          ),
        ),
        Expanded(
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Image.network(
                    imageUrl!,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _BusPlaceholder(),
                  ),
                )
              : _BusPlaceholder(),
        ),
      ],
    );
  }
}

class _BusPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus_outlined,
              size: 20, color: AppColors.primary),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Bus',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
