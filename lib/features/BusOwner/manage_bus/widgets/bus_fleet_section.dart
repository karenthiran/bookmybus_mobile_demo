import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../models/manage_bus_model.dart';
import 'bus_fleet_card.dart';

class BusFleetSection extends StatelessWidget {
  const BusFleetSection({super.key, required this.buses});

  final List<BusFleetModel> buses;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Your Buses',
              style: tt.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: Text(
                'Total Buses: ${buses.length}',
                style: tt.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buses.length,
          itemBuilder: (_, i) => BusFleetCard(bus: buses[i]),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}