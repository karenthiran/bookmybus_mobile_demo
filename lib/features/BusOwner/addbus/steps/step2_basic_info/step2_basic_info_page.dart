import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/bus_form_fields.dart';
import 'widgets/route_info_section.dart';

class Step2BasicInfoPage extends StatefulWidget {
  const Step2BasicInfoPage({super.key, this.standalone = true});

  final bool standalone;

  @override
  State<Step2BasicInfoPage> createState() => Step2BasicInfoPageState();
}

// Public so add_bus_page can call validate() via GlobalKey
class Step2BasicInfoPageState extends State<Step2BasicInfoPage> {

  final _busName = TextEditingController();
  final _regNumber = TextEditingController();
  final _totalSeats = TextEditingController();
  final _pricePerSeat = TextEditingController();
  final _phone = TextEditingController();
  final _conductorPhone = TextEditingController();
  final _fromCity = TextEditingController();
  final _toCity = TextEditingController();

  String? _busNameError;
  String? _regNumberError;
  String? _totalSeatsError;
  String? _pricePerSeatError;
  String? _phoneError;
  String? _fromCityError;
  String? _toCityError;

  /// Called by [AddBusPage] on submit. Returns true if all required fields are valid.
  bool validate() {
    setState(() {
      _busNameError = _busName.text.trim().isEmpty ? 'Bus Name is required.' : null;
      _regNumberError = _regNumber.text.trim().isEmpty ? 'Bus Registration No is required.' : null;
      _totalSeatsError = _totalSeats.text.trim().isEmpty ? 'Seats is required.' : null;
      _pricePerSeatError = _pricePerSeat.text.trim().isEmpty ? 'Price per Seat (LKR) is required.' : null;
      _phoneError = _phone.text.trim().isEmpty ? 'WhatsApp Number is required.' : null;
      _fromCityError = _fromCity.text.trim().isEmpty ? 'Route From is required.' : null;
      _toCityError = _toCity.text.trim().isEmpty ? 'Route To is required.' : null;
    });
    return _busNameError == null &&
        _regNumberError == null &&
        _totalSeatsError == null &&
        _pricePerSeatError == null &&
        _phoneError == null &&
        _fromCityError == null &&
        _toCityError == null;
  }

  @override
  void dispose() {
    _busName.dispose();
    _regNumber.dispose();
    _totalSeats.dispose();
    _pricePerSeat.dispose();
    _phone.dispose();
    _conductorPhone.dispose();
    _fromCity.dispose();
    _toCity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Basic Information', style: tt.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Provide the essential details for your bus entry.', style: tt.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          const BusFieldLabel('Bus Name'),
          BusFormField(
            controller: _busName,
            hint: 'e.g. Southern Express',
            suffixIcon: Icons.directions_bus_outlined,
            errorText: _busNameError,
            onChanged: (_) => setState(() => _busNameError = null),
          ),
          const SizedBox(height: AppSpacing.lg),
          const BusFieldLabel('Registration Number'),
          BusFormField(
            controller: _regNumber,
            hint: 'e.g. NC-1234',
            suffixIcon: Icons.credit_card_outlined,
            textCapitalization: TextCapitalization.characters,
            errorText: _regNumberError,
            onChanged: (_) => setState(() => _regNumberError = null),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BusFieldLabel('Total Seats'),
                    BusFormField(
                      controller: _totalSeats,
                      hint: 'e.g. 45',
                      suffixIcon: Icons.event_seat_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      errorText: _totalSeatsError,
                      onChanged: (_) => setState(() => _totalSeatsError = null),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BusFieldLabel('Price per Seat (LKR)'),
                    BusFormField(
                      controller: _pricePerSeat,
                      hint: 'e.g. 2500',
                      suffixIcon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      errorText: _pricePerSeatError,
                      onChanged: (_) => setState(() => _pricePerSeatError = null),
                    ),
                    const BusFieldHint('Actual ticket price paid by passengers. The platform fee (LKR 100/seat) and payment gateway charge (2.99%) are deducted automatically.'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const BusFieldLabel('WhatsApp Number (Sri Lankan)'),
          BusPhoneField(
            controller: _phone,
            errorText: _phoneError,
            onChanged: (_) => setState(() => _phoneError = null),
          ),
          const BusFieldHint('Enter a valid Sri Lankan mobile number.'),
          const SizedBox(height: AppSpacing.lg),
          const BusFieldLabel('Conductor Number (Sri Lankan)'),
          BusPhoneField(controller: _conductorPhone),
          const BusFieldHint('Optional. If left empty, the WhatsApp number above will be used as the conductor number.'),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          const SizedBox(height: AppSpacing.xl),
          RouteInfoSection(
            fromController: _fromCity,
            toController: _toCity,
            fromErrorText: _fromCityError,
            toErrorText: _toCityError,
            onFromChanged: (_) => setState(() => _fromCityError = null),
            onToChanged: (_) => setState(() => _toCityError = null),
          ),
        ],
      );
    return widget.standalone
        ? SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.lg), child: content)
        : Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: content);
  }
}
