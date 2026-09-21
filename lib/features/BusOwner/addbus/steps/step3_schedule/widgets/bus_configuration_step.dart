import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'bus_type_dropdown.dart';
import 'flip_seat_toggle.dart';
import 'seat_layout_selector.dart';

class BusConfigurationStep extends StatefulWidget {
  const BusConfigurationStep({super.key});

  @override
  State<BusConfigurationStep> createState() => BusConfigurationStepState();
}

// Public so AddBusPage can call validate() via GlobalKey
class BusConfigurationStepState extends State<BusConfigurationStep> {
  String? _busType;
  String? _seatLayout;
  bool _flipLayout = false;

  String? _busTypeError;
  String? _seatLayoutError;

  /// Called by [AddBusPage] on submit. Returns true if all required fields are valid.
  bool validate() {
    setState(() {
      _busTypeError = _busType == null ? 'Bus Type is required.' : null;
      _seatLayoutError = _seatLayout == null ? 'Seat Layout is required.' : null;
    });
    return _busTypeError == null && _seatLayoutError == null;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bus Configuration', style: tt.titleMedium),
        const SizedBox(height: AppSpacing.xl),

        _RequiredFieldLabel('Bus Type'),
        const SizedBox(height: AppSpacing.xs),
        BusTypeDropdown(
          value: _busType,
          onChanged: (v) => setState(() {
            _busType = v;
            _busTypeError = null;
          }),
          errorText: _busTypeError,
        ),
        const SizedBox(height: AppSpacing.xl),

        _RequiredFieldLabel('Seat Layout'),
        const SizedBox(height: AppSpacing.sm),
        SeatLayoutSelector(
          selected: _seatLayout,
          onChanged: (v) => setState(() {
            _seatLayout = v;
            _seatLayoutError = null;
          }),
          errorText: _seatLayoutError,
        ),
        const SizedBox(height: AppSpacing.xl),

        FlipSeatToggle(
          value: _flipLayout,
          onChanged: (v) => setState(() => _flipLayout = v),
        ),
      ],
    );
  }
}

class _RequiredFieldLabel extends StatelessWidget {
  const _RequiredFieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
