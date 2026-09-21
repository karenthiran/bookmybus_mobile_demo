import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/journey_bus_model.dart';

class JourneyBusCard extends StatelessWidget {
  const JourneyBusCard({super.key, required this.bus, required this.date});

  final JourneyBusModel bus;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final arr = bus.arrival;

    return Container(
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
          // ── Header bar ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            color: AppColors.primary,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    bus.routeName,
                    style: tt.bodyMedium?.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                _Chip(label: bus.busType, color: const Color(0xFF059669)),
                const SizedBox(width: AppSpacing.xs),
                _Chip(label: bus.frequency, color: const Color(0xFF2563EB)),
              ],
            ),
          ),

          // ── Midnight Journey banner ──────────────────────────────────────────
          if (bus.isMidnightJourney)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.warningLight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.nightlight_round,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Midnight Journey: This trip starts at night and ends the next day. '
                      'Please plan your travel accordingly.',
                      style: tt.bodySmall?.copyWith(
                          color: const Color(0xFF92400E),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Bus name & reg ─────────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.directions_bus,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bus.busName,
                              style: tt.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          Text(bus.registrationNumber,
                              style: tt.bodySmall?.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'LKR ${bus.ticketPrice.toStringAsFixed(0)}',
                          style: tt.titleSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('per seat',
                            style: tt.bodySmall
                                ?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),

                // ── Journey timeline ───────────────────────────────────────────
                Row(
                  children: [
                    // Departure
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Departure',
                              style: tt.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                          Text(bus.departureTime,
                              style: tt.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.trip_origin,
                                  size: 12, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(bus.from,
                                    style: tt.bodySmall?.copyWith(
                                        color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Duration
                    Column(
                      children: [
                        Text(bus.durationLabel,
                            style: tt.bodySmall?.copyWith(
                                color: AppColors.textSecondary, fontSize: 11)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                                width: 24,
                                height: 1,
                                color: AppColors.border),
                            const Icon(Icons.directions_bus_outlined,
                                size: 16, color: AppColors.textHint),
                            Container(
                                width: 24,
                                height: 1,
                                color: AppColors.border),
                          ],
                        ),
                      ],
                    ),

                    // Arrival
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Arrival',
                              style: tt.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(bus.arrivalTime,
                                  style: tt.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary)),
                              if (arr.isNextDay) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningLight,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.round),
                                  ),
                                  child: Text('+1',
                                      style: tt.bodySmall?.copyWith(
                                          color: AppColors.warning,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(bus.to,
                                    style: tt.bodySmall?.copyWith(
                                        color: AppColors.textSecondary),
                                    textAlign: TextAlign.end),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.location_on,
                                  size: 12, color: AppColors.error),
                            ],
                          ),
                          if (arr.isNextDay)
                            Text('Next Day',
                                style: tt.bodySmall?.copyWith(
                                    color: AppColors.warning,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.end)
                          else
                            Text('Same Day',
                                style: tt.bodySmall?.copyWith(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.end),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: AppSpacing.md),

                // ── Seats row ──────────────────────────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.event_seat,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Available Seats: ',
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.textSecondary)),
                    Text('${bus.availableSeats}/${bus.totalSeats}',
                        style: tt.bodySmall?.copyWith(
                            color: bus.availableSeats <= 10
                                ? AppColors.error
                                : AppColors.success,
                            fontWeight: FontWeight.bold)),
                    if (bus.availableSeats <= 10) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text('(Filling fast!)',
                          style: tt.bodySmall?.copyWith(
                              color: AppColors.error, fontSize: 11)),
                    ],
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Action buttons ─────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.schedule, size: 16),
                        label: const Text('Timetable'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.confirmation_number, size: 16),
                        label: const Text('Book Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(AppRadius.round)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
