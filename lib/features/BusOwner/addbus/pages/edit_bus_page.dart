import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../manage_bus/models/manage_bus_model.dart';
import '../steps/step3_schedule/widgets/pickup_drop_points.dart';
import '../widgets/edit_bus_sections.dart';

class EditBusPage extends StatefulWidget {
  const EditBusPage({super.key, required this.bus});

  final BusFleetModel bus;

  @override
  State<EditBusPage> createState() => _EditBusPageState();
}

class _EditBusPageState extends State<EditBusPage> {
  late final TextEditingController _busName;
  late final TextEditingController _price;
  late final TextEditingController _whatsapp;
  late final TextEditingController _conductor;

  late String _busType;
  late String _frequency;
  TimeOfDay? _departure;
  TimeOfDay? _arrival;
  bool _arrivesNextDay = false;
  late final TextEditingController _additionalFeatures;
  late Set<String> _amenities;

  static const _allAmenities = [
    ('A/C', Icons.ac_unit_outlined),
    ('WiFi', Icons.wifi_outlined),
    ('Charging Ports', Icons.electrical_services_outlined),
    ('Reclining Seats', Icons.airline_seat_recline_extra_outlined),
    ('TV', Icons.tv_outlined),
    ('Music', Icons.music_note_outlined),
    ('Water Bottle', Icons.water_drop_outlined),
    ('Blanket', Icons.bed_outlined),
  ];

  static const _busTypes = ['Super Luxury', 'Luxury', 'Semi-Luxury', 'Normal'];
  static const _frequencies = ['Daily', 'Every Other Day'];

  @override
  void initState() {
    super.initState();
    _busName = TextEditingController(text: widget.bus.busName);
    _price = TextEditingController(text: widget.bus.price);
    _whatsapp = TextEditingController();
    _conductor = TextEditingController();

    _busType = _busTypes.contains(widget.bus.busType)
        ? widget.bus.busType
        : _busTypes[0];
    _frequency = _frequencies.contains(widget.bus.frequency)
        ? widget.bus.frequency
        : _frequencies[0];
    _departure = _parseTime(widget.bus.departure);
    _arrival = _parseTime(widget.bus.arrival);
    _amenities = widget.bus.amenities.toSet();
    _additionalFeatures = TextEditingController();
  }

  @override
  void dispose() {
    _busName.dispose();
    _price.dispose();
    _whatsapp.dispose();
    _conductor.dispose();
    _additionalFeatures.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String raw) {
    try {
      final parts = raw.split(' ');
      final hm = parts[0].split(':');
      int hour = int.parse(hm[0]);
      final minute = int.parse(hm[1]);
      if (parts.length > 1) {
        if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
        if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;
      }
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickTime(bool isDeparture) async {
    final initial = (isDeparture ? _departure : _arrival) ?? TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      if (isDeparture) {
        _departure = picked;
      } else {
        _arrival = picked;
      }
    });
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '—';
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _onSave() {
    // TODO: persist updated values
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bus updated successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final bus = widget.bus;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text('Edit Bus', style: tt.titleMedium),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subtitle ──────────────────────────────────────────
            Text(
              'Editable fields are clearly marked. Platform-controlled fields are read-only for safety and consistency.',
              style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Platform Controlled ───────────────────────────────
            EditBusPlatformSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReadOnlyField(
                    label: 'Bus Registration No',
                    value: bus.registrationNo,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Seats',
                          value: '${bus.totalSeats}',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Seat Layout',
                          value: bus.seatLayout.isEmpty ? '—' : bus.seatLayout,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Route From',
                          value: bus.fromCity,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Route To',
                          value: bus.toCity,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Status',
                          value:
                              bus.approvalStatus.name[0].toUpperCase() +
                              bus.approvalStatus.name.substring(1),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ReadOnlyField(
                          label: 'Active?',
                          value: bus.status == BusStatus.active
                              ? 'Active'
                              : 'Inactive',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ReadOnlyField(label: 'Flip Seat Layout', value: 'Normal'),
                ],
              ),
            ),

            // ── Editable by You ───────────────────────────────────
            EditBusDetailsSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bus Name
                  _FieldLabel(text: 'Bus Name', required: true),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _textField(
                    controller: _busName,
                    hint: 'e.g. LION SUPER LINE',
                    icon: Icons.directions_bus_outlined,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Price
                  _FieldLabel(text: 'Price per Seat (LKR)', required: true),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _textField(
                    controller: _price,
                    hint: 'e.g. 1850',
                    icon: Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _HintText(
                    'Actual ticket price paid by passengers. Platform fee (LKR 100/seat) and payment gateway charge (2.99%) are deducted automatically.',
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Bus Image
                  _FieldLabel(text: 'Bus Image', required: true),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _ImageUploadField(imageUrl: bus.imageUrl),

                  const SizedBox(height: AppSpacing.lg),

                  // Bus Type
                  _FieldLabel(text: 'Bus Type', required: true),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _DropdownField<String>(
                    value: _busType,
                    items: _busTypes,
                    itemLabel: (v) => v,
                    onChanged: (v) => setState(() => _busType = v!),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Frequency
                  _FieldLabel(text: 'Frequency', required: true),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _DropdownField<String>(
                    value: _frequency,
                    items: _frequencies,
                    itemLabel: (v) => v,
                    onChanged: (v) => setState(() => _frequency = v!),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // WhatsApp
                  _FieldLabel(
                    text: 'Operations WhatsApp Number',
                    required: true,
                  ),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _PhoneField(controller: _whatsapp, hint: '0775454166'),
                  const SizedBox(height: AppSpacing.xs),
                  _HintText('Enter a valid Sri Lankan mobile number.'),

                  const SizedBox(height: AppSpacing.lg),

                  // Conductor
                  _FieldLabel(text: 'Conductor Number', required: false),
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  _PhoneField(
                    controller: _conductor,
                    hint: 'e.g., 0771234567 or +94771234567',
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _HintText(
                    'Optional. If left empty, the WhatsApp number above will be used as the conductor number.',
                  ),
                ],
              ),
            ),

            // ── Schedule ──────────────────────────────────────────
            EditBusScheduleSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'Departure Time',
                          required: true,
                          value: _formatTime(_departure),
                          onTap: () => _pickTime(true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _TimePickerField(
                          label: 'Arrival Time',
                          required: true,
                          value: _formatTime(_arrival),
                          onTap: () => _pickTime(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ArrivesNextDayToggle(
                    value: _arrivesNextDay,
                    onChanged: (v) => setState(() => _arrivesNextDay = v),
                  ),
                ],
              ),
            ),

            // ── Amenities ─────────────────────────────────────────
            EditBusAmenitiesSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _allAmenities.map((a) {
                      final selected = _amenities.contains(a.$1);
                      return _AmenityChip(
                        label: a.$1,
                        icon: a.$2,
                        selected: selected,
                        onTap: () => setState(() {
                          selected
                              ? _amenities.remove(a.$1)
                              : _amenities.add(a.$1);
                        }),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // ── Additional Features ───────────────────────────────
            EditBusAdditionalFeaturesSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'comma-separated',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _additionalFeatures,
                    maxLines: 3,
                    style: tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
                    decoration: _inputDecoration(
                      hint: 'e.g., Curtains, Extra legroom, USB charging',
                    ).copyWith(alignLabelWithHint: true),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _HintText('Example: Curtains, USB Charging, Reclining Seats'),
                ],
              ),
            ),

            // ── Pick-up Points ────────────────────────────────────
            EditBusPickupSection(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditableTag(),
                  const SizedBox(height: AppSpacing.md),
                  PickupDropPoints(
                    onChanged: (_) {},
                    startPlace: bus.fromCity,
                    startTime: bus.departure,
                    endPlace: bus.toCity,
                    endTime: bus.arrival,
                    intermediateStops: bus.pickups
                        .map((p) => {'place': p.city, 'time': p.time})
                        .toList(),
                  ),
                ],
              ),
            ),

            // Save
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onSave,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      decoration: _inputDecoration(
        hint: hint,
        suffixIcon: Icon(icon, size: 18, color: AppColors.textHint),
      ),
    );
  }
}

// ── Read-Only Field ───────────────────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: tt.bodySmall?.copyWith(
                  color: AppColors.textHint,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.lock_outline_rounded,
                size: 11,
                color: AppColors.textDisabled,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: tt.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Field Label ───────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.required});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          text,
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: tt.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

// ── Editable Tag ──────────────────────────────────────────────────────────────

class _EditableTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 1),
      child: Row(
        children: [
          const Icon(Icons.edit_outlined, size: 11, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            'Editable',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hint Text ─────────────────────────────────────────────────────────────────

class _HintText extends StatelessWidget {
  const _HintText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textHint, fontSize: 11),
    );
  }
}

// ── Dropdown Field ────────────────────────────────────────────────────────────

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      decoration: _inputDecoration(hint: ''),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))))
          .toList(),
    );
  }
}

// ── Phone Field ───────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  static const _whatsappGreen = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\+]')),
      ],
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      decoration: _inputDecoration(
        hint: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.section,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇱🇰', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '+94',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        suffixIcon: const Icon(Icons.phone, size: 20, color: _whatsappGreen),
      ),
    );
  }
}

// ── Image Upload Field ────────────────────────────────────────────────────────

class _ImageUploadField extends StatelessWidget {
  const _ImageUploadField({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Preview area
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.section,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.sm),
              ),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.sm),
                    ),
                    child: Image.network(imageUrl!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Bus preview image',
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // TODO: pick image
                    icon: const Icon(Icons.upload_outlined, size: 16),
                    label: const Text('Upload'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // TODO: remove image
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amenity Chip ─────────────────────────────────────────────────────────────

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : icon,
              size: 15,
              color: selected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: selected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Time Picker Field ────────────────────────────────────────────────────────

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.label,
    required this.required,
    required this.value,
    required this.onTap,
  });

  final String label;
  final bool required;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value,
                    style: tt.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Arrives Next Day Toggle ───────────────────────────────────────────────────

class _ArrivesNextDayToggle extends StatelessWidget {
  const _ArrivesNextDayToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: value ? AppColors.infoLight : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: value ? AppColors.info : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.nights_stay_outlined,
            size: 18,
            color: value ? AppColors.info : AppColors.textHint,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Arrives next day?',
              style: tt.bodyMedium?.copyWith(
                color: value ? AppColors.info : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.info,
          ),
        ],
      ),
    );
  }
}

// ── Shared InputDecoration ────────────────────────────────────────────────────

InputDecoration _inputDecoration({
  String hint = '',
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textHint),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
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
  );
}
