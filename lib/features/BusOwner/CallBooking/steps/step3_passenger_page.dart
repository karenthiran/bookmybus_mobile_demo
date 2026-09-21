import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/widgets/step_3/form_field.dart' as step3;
import 'package:flutter/material.dart';
import '../models/call_booking_model.dart';

class Step3PassengerPage extends StatefulWidget {
  const Step3PassengerPage({
    super.key,
    required this.booking,
    required this.onChanged,
  });
  final CallBookingModel booking;
  final VoidCallback onChanged;

  @override
  State<Step3PassengerPage> createState() => _Step3PassengerPageState();
}

class _Step3PassengerPageState extends State<Step3PassengerPage> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _nicCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _pickupPointCtrl;
  late final TextEditingController _dropPointCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final nameParts = widget.booking.passengerName.trim().split(RegExp(r'\s+'));
    _firstNameCtrl = TextEditingController(
      text: widget.booking.passengerName.isEmpty ? '' : nameParts.first,
    );
    _lastNameCtrl = TextEditingController(
      text: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
    );
    _phoneCtrl = TextEditingController(text: widget.booking.passengerPhone);
    _nicCtrl = TextEditingController(text: widget.booking.passengerNic);
    _emailCtrl = TextEditingController(text: widget.booking.passengerEmail);
    _setDefaultPoints();
    _pickupPointCtrl = TextEditingController(text: widget.booking.pickupPoint);
    _dropPointCtrl = TextEditingController(text: widget.booking.dropPoint);
    _notesCtrl = TextEditingController(text: widget.booking.passengerNotes);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _nicCtrl.dispose();
    _emailCtrl.dispose();
    _pickupPointCtrl.dispose();
    _dropPointCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    widget.booking.passengerName =
        '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim();
    widget.booking.passengerPhone = _phoneCtrl.text.trim();
    widget.booking.passengerNic = _nicCtrl.text.trim();
    widget.booking.passengerEmail = _emailCtrl.text.trim();
    widget.booking.pickupPoint = _pickupPointCtrl.text.trim();
    widget.booking.dropPoint = _dropPointCtrl.text.trim();
    widget.booking.passengerNotes = _notesCtrl.text.trim();
    widget.onChanged();
  }

  void _setDefaultPoints() {
    final trip = widget.booking.selectedTrip;
    if (trip == null) return;
    widget.booking.pickupPoint = widget.booking.pickupPoint.isNotEmpty
        ? widget.booking.pickupPoint
        : (trip.pickupPoints.isNotEmpty ? trip.pickupPoints.first : trip.from);
    widget.booking.dropPoint = widget.booking.dropPoint.isNotEmpty
        ? widget.booking.dropPoint
        : (trip.dropPoints.isNotEmpty ? trip.dropPoints.last : trip.to);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.section,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Passenger Details',
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.divider, height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      step3.PassengerFormField(
                        label: 'First Name *',
                        hint: 'Enter first name',
                        controller: _firstNameCtrl,
                        keyboardType: TextInputType.name,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Last Name *',
                        hint: 'Enter last name',
                        controller: _lastNameCtrl,
                        keyboardType: TextInputType.name,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Contact No *',
                        hint: 'Enter contact number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'NIC (optional)',
                        hint: 'Enter NIC number',
                        controller: _nicCtrl,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Email (optional)',
                        hint: 'Enter email address',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Pickup Point',
                        hint: 'Enter pickup point',
                        controller: _pickupPointCtrl,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Drop Point',
                        hint: 'Enter drop point',
                        controller: _dropPointCtrl,
                        onChanged: (_) => _sync(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      step3.PassengerFormField(
                        label: 'Notes (optional)',
                        hint: 'Add any special instructions',
                        controller: _notesCtrl,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        onChanged: (_) => _sync(),
                      ),
                    ],
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
