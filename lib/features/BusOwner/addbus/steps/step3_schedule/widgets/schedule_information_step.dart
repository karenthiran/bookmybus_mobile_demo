import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'additional_features_input.dart';
import 'amenities_selector.dart';
import 'bus_configuration_step.dart';
import 'pickup_drop_points.dart';

import 'frequency_card.dart';
import 'guidance_banner.dart';
import 'manual_trip_card.dart';
import 'schedule_time_fields.dart';

enum _Frequency { everyday, everyOtherDay, manual }

class ScheduleInformationStep extends StatefulWidget {
  const ScheduleInformationStep({
    super.key,
    this.fromCity = 'Departure City',
    this.toCity = 'Destination City',
    this.standalone = true,
    this.busConfigKey,
  });

  final String fromCity;
  final String toCity;
  final bool standalone;
  final GlobalKey<BusConfigurationStepState>? busConfigKey;

  @override
  State<ScheduleInformationStep> createState() =>
      ScheduleInformationStepState();
}

// Public so AddBusPage can call validate() via GlobalKey
class ScheduleInformationStepState extends State<ScheduleInformationStep> {
  _Frequency _frequency = _Frequency.everyday;

  // Everyday / Every Other Day
  final _depTime = TextEditingController();
  final _arrTime = TextEditingController();
  bool _arrivesNextDay = false;

  // Every Other Day – start date
  final _eodStartDate = TextEditingController();

  // Manual – shared
  final _startDate = TextEditingController();

  // Manual – up trip
  final _upDep = TextEditingController();
  final _upArr = TextEditingController();
  bool _upNextDay = false;

  // Manual – down trip
  final _downDep = TextEditingController();
  final _downArr = TextEditingController();
  bool _downNextDay = false;

  // Validation errors
  String? _depTimeError;
  String? _arrTimeError;
  String? _eodStartDateError;
  String? _startDateError;
  String? _upDepError;
  String? _upArrError;
  String? _downDepError;
  String? _downArrError;

  /// Called by [AddBusPage] on submit. Returns true if all required fields are valid.
  bool validate() {
    setState(() {
      if (_frequency == _Frequency.everyday) {
        _depTimeError = _depTime.text.trim().isEmpty ? 'Departure Time is required.' : null;
        _arrTimeError = _arrTime.text.trim().isEmpty ? 'Arrival Time is required.' : null;
        _eodStartDateError = null;
        _startDateError = null;
        _upDepError = null; _upArrError = null;
        _downDepError = null; _downArrError = null;
      } else if (_frequency == _Frequency.everyOtherDay) {
        _eodStartDateError = _eodStartDate.text.trim().isEmpty ? 'Starting Date is required.' : null;
        _depTimeError = _depTime.text.trim().isEmpty ? 'Departure Time is required.' : null;
        _arrTimeError = _arrTime.text.trim().isEmpty ? 'Arrival Time is required.' : null;
        _startDateError = null;
        _upDepError = null; _upArrError = null;
        _downDepError = null; _downArrError = null;
      } else {
        _startDateError = _startDate.text.trim().isEmpty ? 'Starting Date is required.' : null;
        _upDepError = _upDep.text.trim().isEmpty ? 'Departure Time is required.' : null;
        _upArrError = _upArr.text.trim().isEmpty ? 'Arrival Time is required.' : null;
        _downDepError = _downDep.text.trim().isEmpty ? 'Departure Time is required.' : null;
        _downArrError = _downArr.text.trim().isEmpty ? 'Arrival Time is required.' : null;
        _depTimeError = null; _arrTimeError = null;
        _eodStartDateError = null;
      }
    });
    if (_frequency == _Frequency.everyday) {
      return _depTimeError == null && _arrTimeError == null;
    } else if (_frequency == _Frequency.everyOtherDay) {
      return _eodStartDateError == null && _depTimeError == null && _arrTimeError == null;
    } else {
      return _startDateError == null && _upDepError == null && _upArrError == null &&
          _downDepError == null && _downArrError == null;
    }
  }

  @override
  void dispose() {
    _depTime.dispose();
    _arrTime.dispose();
    _eodStartDate.dispose();
    _startDate.dispose();
    _upDep.dispose();
    _upArr.dispose();
    _downDep.dispose();
    _downArr.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      controller.text = picked.format(context);
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && mounted) {
      controller.text =
          '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Guidance Banner ───────────────────────────────────────
          const GuidanceBanner(
            message: 'Ensure times are accurate for passengers.',
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Frequency Toggle ──────────────────────────────────────
          _RequiredLabel('Frequency', tt),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '📅',
            title: 'Everyday',
            subtitle:
                'Bus runs every day using the departure & arrival times set above.',
            selected: _frequency == _Frequency.everyday,
            onTap: () => setState(() => _frequency = _Frequency.everyday),
          ),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '📆',
            title: 'Every Other Day',
            subtitle:
                'Bus runs every alternate day using departure & arrival times.',
            selected: _frequency == _Frequency.everyOtherDay,
            onTap: () => setState(() => _frequency = _Frequency.everyOtherDay),
          ),
          const SizedBox(height: AppSpacing.sm),
          FrequencyCard(
            emoji: '✏️',
            title: 'Manual',
            subtitle:
                'Set a start date and exact up/down departure times. The bus will repeat this daily routine from the start date.',
            selected: _frequency == _Frequency.manual,
            onTap: () => setState(() => _frequency = _Frequency.manual),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Dynamic Content ───────────────────────────────────────
          if (_frequency == _Frequency.everyday)
            ScheduleTimeFields(
              departureController: _depTime,
              arrivalController: _arrTime,
              arrivesNextDay: _arrivesNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _arrivesNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_depTime),
              onArrivalTap: () => _pickTime(_arrTime),
              departureErrorText: _depTimeError,
              arrivalErrorText: _arrTimeError,
              onDepartureChanged: (_) => setState(() => _depTimeError = null),
              onArrivalChanged: (_) => setState(() => _arrTimeError = null),
            ),

          if (_frequency == _Frequency.everyOtherDay) ...[
            // Start date section
            Text('Every Other Day — Start Date', style: tt.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The bus will run on this date and every 2nd day after.',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _RequiredLabel('Starting Date', tt),
            const SizedBox(height: AppSpacing.xs),
            _DatePickerField(
              controller: _eodStartDate,
              onTap: () => _pickDate(_eodStartDate),
              errorText: _eodStartDateError,
              onChanged: () => setState(() => _eodStartDateError = null),
            ),
            const SizedBox(height: AppSpacing.xl),
            ScheduleTimeFields(
              departureController: _depTime,
              arrivalController: _arrTime,
              arrivesNextDay: _arrivesNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _arrivesNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_depTime),
              onArrivalTap: () => _pickTime(_arrTime),
              departureErrorText: _depTimeError,
              arrivalErrorText: _arrTimeError,
              onDepartureChanged: (_) => setState(() => _depTimeError = null),
              onArrivalChanged: (_) => setState(() => _arrTimeError = null),
            ),
          ],

          if (_frequency == _Frequency.manual) ...[
            Text('Manual Daily Schedule', style: tt.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Set a start date. From that date, the bus runs this same routine every day.',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Starting Date
            _RequiredLabel('Starting Date', tt),
            const SizedBox(height: AppSpacing.xs),
            _DatePickerField(
              controller: _startDate,
              onTap: () => _pickDate(_startDate),
              errorText: _startDateError,
              onChanged: () => setState(() => _startDateError = null),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Up Trip
            ManualTripCard(
              isUpTrip: true,
              title: '${widget.fromCity} → ${widget.toCity}',
              departureController: _upDep,
              arrivalController: _upArr,
              arrivesNextDay: _upNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _upNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_upDep),
              onArrivalTap: () => _pickTime(_upArr),
              departureErrorText: _upDepError,
              arrivalErrorText: _upArrError,
              onDepartureChanged: (_) => setState(() => _upDepError = null),
              onArrivalChanged: (_) => setState(() => _upArrError = null),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Down Trip
            ManualTripCard(
              isUpTrip: false,
              title: '${widget.toCity} → ${widget.fromCity}',
              departureController: _downDep,
              arrivalController: _downArr,
              arrivesNextDay: _downNextDay,
              onArrivesNextDayChanged: (v) =>
                  setState(() => _downNextDay = v ?? false),
              onDepartureTap: () => _pickTime(_downDep),
              onArrivalTap: () => _pickTime(_downArr),
              departureErrorText: _downDepError,
              arrivalErrorText: _downArrError,
              onDepartureChanged: (_) => setState(() => _downDepError = null),
              onArrivalChanged: (_) => setState(() => _downArrError = null),
            ),
          ],

          // ── Bus Configuration ─────────────────────────────────────
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          BusConfigurationStep(key: widget.busConfigKey),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          const AmenitiesSelector(),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          const AdditionalFeaturesInput(),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: AppSpacing.xl),
          const PickupDropPoints(),
        ],
      );
    return widget.standalone
        ? SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: content)
        : Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: content);
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.controller,
    required this.onTap,
    this.errorText,
    this.onChanged,
  });
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? errorText;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            onTap();
            onChanged?.call();
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              readOnly: true,
              style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                hintStyle: tt.bodyMedium?.copyWith(color: AppColors.textHint),
                suffixIcon: const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppColors.textHint),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: errorText != null ? AppColors.error : const Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: errorText != null ? AppColors.error : AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: tt.bodySmall?.copyWith(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel(this.text, this.tt);
  final String text;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: tt.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
                color: AppColors.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
