import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class EditBusPlatformSection extends StatelessWidget {
  const EditBusPlatformSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Platform Controlled',
          badge: 'Admin-only',
          badgeColor: AppColors.error,
          badgeBg: AppColors.errorLight,
          icon: Icons.lock_outline_rounded,
          iconColor: AppColors.error,
        ),
        const SizedBox(height: AppSpacing.md),
        content,
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class EditBusDetailsSection extends StatelessWidget {
  const EditBusDetailsSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Editable by You',
          icon: Icons.edit_outlined,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        content,
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class EditBusScheduleSection extends StatelessWidget {
  const EditBusScheduleSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Schedule',
          icon: Icons.schedule_outlined,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        content,
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class EditBusAmenitiesSection extends StatelessWidget {
  const EditBusAmenitiesSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Amenities',
          icon: Icons.star_outline_rounded,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.xs),
        content,
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class EditBusAdditionalFeaturesSection extends StatelessWidget {
  const EditBusAdditionalFeaturesSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Additional Features',
          icon: Icons.add_circle_outline_rounded,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.xs),
        content,
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

class EditBusPickupSection extends StatelessWidget {
  const EditBusPickupSection({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBusSectionHeader(
          label: 'Pick-up Points',
          icon: Icons.location_on_outlined,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.xs),
        content,
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }
}

class EditBusSectionHeader extends StatelessWidget {
  const EditBusSectionHeader({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.badge,
    this.badgeColor,
    this.badgeBg,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeBg;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: tt.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(AppRadius.round),
            ),
            child: Text(
              badge!,
              style: tt.labelSmall?.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
