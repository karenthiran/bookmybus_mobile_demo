import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../data/dummy_booking_history.dart';

class ViewBookingCard extends StatelessWidget {
  const ViewBookingCard({
    super.key,
    required this.selectedBus,
    required this.selectedDate,
    required this.onBusChanged,
    required this.onDateChanged,
    required this.onView,
  });

  final String selectedBus;
  final DateTime selectedDate;
  final ValueChanged<String> onBusChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return _Card(
      title: 'View Booking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Select Bus'),
          const SizedBox(height: AppSpacing.xs),
          _Dropdown(
            value: selectedBus,
            items: DummyBookingHistory.buses,
            onChanged: onBusChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Travel Date'),
          const SizedBox(height: AppSpacing.xs),
          _DateField(date: selectedDate, onChanged: onDateChanged),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onView,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                'View',
                style: tt.labelLarge?.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Booking Overview Card ────────────────────────────────────────────────────

class BookingOverviewCard extends StatelessWidget {
  const BookingOverviewCard({
    super.key,
    required this.selectedBus,
    required this.selectedRoute,
    required this.selectedStatus,
    required this.selectedDate,
    required this.fromDate,
    required this.toDate,
    required this.onBusChanged,
    required this.onRouteChanged,
    required this.onStatusChanged,
    required this.onDateChanged,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.onClearFilters,
  });

  final String selectedBus;
  final String selectedRoute;
  final String selectedStatus;
  final DateTime selectedDate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final ValueChanged<String> onBusChanged;
  final ValueChanged<String> onRouteChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return _Card(
      title: 'Booking Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Bus'),
          const SizedBox(height: AppSpacing.xs),
          _Dropdown(
            value: selectedBus,
            items: DummyBookingHistory.buses,
            onChanged: onBusChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Route'),
          const SizedBox(height: AppSpacing.xs),
          _Dropdown(
            value: selectedRoute,
            items: DummyBookingHistory.routes,
            onChanged: onRouteChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Status'),
          const SizedBox(height: AppSpacing.xs),
          _Dropdown(
            value: selectedStatus,
            items: DummyBookingHistory.statuses,
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Travel Date (Day)'),
          const SizedBox(height: AppSpacing.xs),
          _DateField(date: selectedDate, onChanged: onDateChanged),
          const SizedBox(height: AppSpacing.md),
          _FieldLabel('Custom Date Range'),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  hint: 'From',
                  date: fromDate,
                  onChanged: onFromDateChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DateField(
                  hint: 'To',
                  date: toDate,
                  onChanged: onToDateChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onClearFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                'Clear Filters',
                style: tt.labelLarge?.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md,
            ),
            child: Text(title, style: tt.titleMedium),
          ),
          const Divider(color: AppColors.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
        ),
      );
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  static const _fillColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isDense: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        filled: true,
        fillColor: _fillColor,
        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textHint),
      ),
      icon: const SizedBox.shrink(),
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: AppColors.textPrimary),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => onChanged(v!),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({this.hint, this.date, required this.onChanged});

  final String? hint;
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _fillColor = Color(0xFFF8FAFC);

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _fillColor,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? _format(date!) : (hint ?? 'Select date'),
              style: tt.bodyLarge?.copyWith(
                color: date != null ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
