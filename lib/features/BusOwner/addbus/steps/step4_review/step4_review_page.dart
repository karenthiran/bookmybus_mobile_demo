import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../step3_schedule/widgets/guidance_banner.dart';

class Step4ReviewPage extends StatelessWidget {
  const Step4ReviewPage({super.key, this.standalone = true});

  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GuidanceBanner(
            message: 'Review all details carefully before submitting.',
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Step 1: Images ────────────────────────────────────────
          _ReviewSection(
            icon: Icons.photo_library_outlined,
            title: 'Bus Images',
            children: const [
              _ReviewRow(label: 'Uploaded Images', value: '3 images'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 2: Basic Info ────────────────────────────────────
          _ReviewSection(
            icon: Icons.directions_bus_outlined,
            title: 'Basic Information',
            children: const [
              _ReviewRow(label: 'Bus Name', value: 'Southern Express'),
              _ReviewRow(label: 'Registration No.', value: 'NC-1234'),
              _ReviewRow(label: 'Total Seats', value: '45'),
              _ReviewRow(label: 'Price per Seat', value: 'LKR 2,500'),
              _ReviewRow(label: 'WhatsApp', value: '+94 77 123 4567'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Route ─────────────────────────────────────────
          _ReviewSection(
            icon: Icons.route_outlined,
            title: 'Route',
            children: const [
              _ReviewRow(label: 'From', value: 'Colombo'),
              _ReviewRow(label: 'To', value: 'Kandy'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Schedule ──────────────────────────────────────
          _ReviewSection(
            icon: Icons.schedule_outlined,
            title: 'Schedule',
            children: const [
              _ReviewRow(label: 'Frequency', value: 'Everyday'),
              _ReviewRow(label: 'Departure', value: '06:30 AM'),
              _ReviewRow(label: 'Arrival', value: '09:45 AM'),
              _ReviewRow(label: 'Arrives Next Day', value: 'No'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Bus Config ────────────────────────────────────
          _ReviewSection(
            icon: Icons.settings_outlined,
            title: 'Bus Configuration',
            children: const [
              _ReviewRow(label: 'Bus Type', value: 'AC Luxury'),
              _ReviewRow(label: 'Seat Layout', value: '2+2'),
              _ReviewRow(label: 'Flip Seat Layout', value: 'No'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Amenities ─────────────────────────────────────
          _ReviewSection(
            icon: Icons.star_outline_rounded,
            title: 'Amenities',
            children: const [
              _ReviewChips(items: ['WiFi', 'AC', 'USB Charging', 'Reclining Seats']),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Additional Features ───────────────────────────
          _ReviewSection(
            icon: Icons.add_circle_outline_rounded,
            title: 'Additional Features',
            children: const [
              _ReviewChips(items: ['Premium legroom', 'USB-C ports', 'Curtains']),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Step 3: Pickup / Drop Points ──────────────────────────
          _ReviewSection(
            icon: Icons.location_on_outlined,
            title: 'Pickup / Drop Points',
            children: const [
              _ReviewRow(label: 'Start', value: 'Colombo Fort — 06:00 AM'),
              _ReviewRow(label: 'Stop 1', value: 'Kadawatha — 06:30 AM'),
              _ReviewRow(label: 'Stop 2', value: 'Ambepussa — 07:15 AM'),
              _ReviewRow(label: 'End', value: 'Kandy — 09:45 AM'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Confirmation notice ───────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 20, color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Everything looks good! Tap "Add Bus to System" to submit.',
                    style: tt.bodyMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      );
    return standalone
        ? SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: content)
        : Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: content);
  }
}

// ── Review Section Card ──────────────────────────────────────────────────────

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.section,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Rows
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ── Label / Value Row ────────────────────────────────────────────────────────

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip List ────────────────────────────────────────────────────────────────

class _ReviewChips extends StatelessWidget {
  const _ReviewChips({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: items
            .map(
              (item) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.section,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  item,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
