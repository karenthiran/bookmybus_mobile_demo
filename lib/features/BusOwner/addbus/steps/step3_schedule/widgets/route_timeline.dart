import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'route_field.dart';
import 'timeline_dot.dart';

class RouteTimeline extends StatelessWidget {
  const RouteTimeline({
    super.key,
    required this.fromController,
    required this.toController,
  });

  final TextEditingController fromController;
  final TextEditingController toController;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const TimelineDot(color: AppColors.success),
              Expanded(child: Container(width: 2, color: AppColors.border)),
              const TimelineDot(color: AppColors.error),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              children: [
                RouteField(
                  controller: fromController,
                  hint: 'Start typing: Colombo...',
                  icon: Icons.location_on,
                  iconColor: AppColors.success,
                  label: 'From City',
                ),
                const SizedBox(height: AppSpacing.lg),
                RouteField(
                  controller: toController,
                  hint: 'Start typing: Kandy...',
                  icon: Icons.location_pin,
                  iconColor: AppColors.error,
                  label: 'To City',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
