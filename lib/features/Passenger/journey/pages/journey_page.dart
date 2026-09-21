import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/Passenger/home/models/bus_route_model.dart';
import 'package:bookmybus/features/Passenger/journey/data/dummy_journey_bus_data.dart';
import 'package:bookmybus/features/Passenger/journey/models/journey_bus_model.dart';
import 'package:bookmybus/features/Passenger/journey/widgets/journey_bus_card.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key, this.route});

  final BusRouteModel? route;

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  late String? _from;
  late String? _to;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _from = widget.route?.from;
    _to = widget.route?.to;
    _date = DateTime.now();
  }

  @override
  void didUpdateWidget(JourneyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.route != oldWidget.route && widget.route != null) {
      setState(() {
        _from = widget.route!.from;
        _to = widget.route!.to;
        _date = DateTime.now();
      });
    }
  }

  void _clearSearch() => setState(() {
        _from = null;
        _to = null;
        _date = DateTime.now();
      });

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  List<JourneyBusModel> get _results {
    if (_from == null || _to == null) return [];
    return DummyJourneyBusData.search(_from!, _to!);
  }


  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasSearch = _from != null && _to != null;
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Journey'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page header ──────────────────────────────────────────────────
            Text('Find Your Perfect Journey',
                style: tt.titleLarge?.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Search and book bus tickets across thousands of routes',
              style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Search card ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _SearchField(
                    label: 'From',
                    value: _from,
                    icon: Icons.trip_origin,
                    iconColor: AppColors.primary,
                    onClear: _from != null
                        ? () => setState(() => _from = null)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SearchField(
                    label: 'To',
                    value: _to,
                    icon: Icons.location_on,
                    iconColor: AppColors.error,
                    onClear:
                        _to != null ? () => setState(() => _to = null) : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DateField(date: _date, onTap: _pickDate),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _clearSearch,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear Search'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Results ──────────────────────────────────────────────────────
            if (hasSearch) ...[
              const SizedBox(height: AppSpacing.xl),

              // Summary header
              Text('Buses',
                  style: tt.titleMedium
                      ?.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: AppSpacing.xs),
              Text('Showing results for your selected route and date',
                  style:
                      tt.bodySmall?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                results.isEmpty
                    ? 'No buses found for this route'
                    : 'Found ${results.length} ${results.length == 1 ? 'bus' : 'buses'} matching your search',
                style: tt.bodySmall?.copyWith(
                  color: results.isEmpty
                      ? AppColors.error
                      : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (results.isEmpty)
                _EmptyResults(from: _from!, to: _to!)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (_, i) =>
                      JourneyBusCard(bus: results[i], date: _date),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Search Field ───────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.onClear,
  });

  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: tt.bodySmall?.copyWith(
                        color: AppColors.textSecondary, fontSize: 11)),
                Text(
                  value ?? 'Select city',
                  style: tt.bodyMedium?.copyWith(
                    color: value != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                    fontWeight:
                        value != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close,
                  size: 16, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

// ── Date Field ─────────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.section,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: AppColors.primary, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Text(
                    '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}',
                    style: tt.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Empty Results ──────────────────────────────────────────────────────────────

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.from, required this.to});
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text('No buses available',
              style: tt.titleSmall
                  ?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.xs),
          Text('No buses found from $from to $to.\nTry a different route or date.',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
