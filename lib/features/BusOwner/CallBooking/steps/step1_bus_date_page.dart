import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/data/call_booking_dummy_data.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/models/call_booking_model.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_1/bus_trip_card.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_1/section_card.dart';
import 'package:flutter/material.dart';

class Step1BusDatePage extends StatefulWidget {
  const Step1BusDatePage({super.key, required this.booking, required this.onChanged});

  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step1BusDatePage> createState() => _Step1BusDatePageState();
}

class _Step1BusDatePageState extends State<Step1BusDatePage> {
  final _searchController = TextEditingController();
  List<CallBusTripModel> _filtered = CallBookingDummyData.trips;

  String _fmtDate(DateTime d) =>
      '${(d.month).toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  void _onSearch(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = CallBookingDummyData.trips.where((t) {
        return t.busName.toLowerCase().contains(lower) ||
            t.busNumber.toLowerCase().contains(lower) ||
            t.route.toLowerCase().contains(lower);
      }).toList();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.booking.travelDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      widget.booking.travelDate = picked;
      widget.onChanged();
    }
  }

  void _selectTrip(CallBusTripModel trip) {
    setState(() => widget.booking.selectedTrip = trip);
    widget.onChanged();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final date = widget.booking.travelDate;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Travel Date ──────────────────────────────────────
          SectionCard(
            title: 'Travel Date',
            icon: Icons.calendar_today_outlined,
            child: GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date != null ? _fmtDate(date) : 'MM/DD/YYYY',
                      style: tt.bodyLarge?.copyWith(
                        color: date != null ? AppColors.textPrimary : AppColors.textHint,
                      ),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Select Bus ───────────────────────────────────────
          SectionCard(
            title: 'Select Bus',
            icon: Icons.directions_bus_outlined,
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by name, number or route...',
                    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 20, color: AppColors.textHint),
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
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Bus cards
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'No buses found.',
                        style: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => BusTripCard(
                      trip: _filtered[i],
                      isSelected:
                          widget.booking.selectedTrip == _filtered[i],
                      onTap: () => _selectTrip(_filtered[i]),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}
