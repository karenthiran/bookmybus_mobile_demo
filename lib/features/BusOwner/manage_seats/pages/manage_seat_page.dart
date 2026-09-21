import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/common_app_bar.dart';
import '../../../BusOwner/manage_bus/models/manage_bus_model.dart';
import '../widgets/seat_editing_widget.dart';
import '../widgets/header_section.dart';
import '../widgets/date_selection_section.dart';
import '../widgets/range_picker_section.dart';
import '../widgets/tips_section.dart';
import '../widgets/bottom_action_bar.dart';

class ManageSeatPage extends StatefulWidget {
  const ManageSeatPage({super.key, required this.bus});

  final BusFleetModel bus;

  @override
  State<ManageSeatPage> createState() => _ManageSeatPageState();
}

class _ManageSeatPageState extends State<ManageSeatPage> {
  DateMode _dateMode = DateMode.single;
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  DateTime? _selectedRangeDate;
  bool _seatsLoaded = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      initialDateRange: _selectedRange,
    );
    if (picked != null) setState(() => _selectedRange = picked);
  }

  void _loadSeats() {
    final valid = _dateMode == DateMode.single
        ? _selectedDate != null
        : _selectedRange != null;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date or date range first.')),
      );
      return;
    }
    setState(() {
      _seatsLoaded = true;
      if (_dateMode == DateMode.range) {
        _selectedRangeDate = _selectedRange!.start;
      }
    });
  }

  String _fmt(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  String _fmtIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: ''),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ManageSeatHeaderSection(busName: widget.bus.busName),
                  const SizedBox(height: AppSpacing.lg),
                  DateSelectionSection(
                    dateMode: _dateMode,
                    selectedDate: _selectedDate,
                    selectedDateRange: _selectedRange,
                    onDateModeChanged: (mode) => setState(() {
                      _dateMode = mode;
                      _seatsLoaded = false;
                      _selectedRangeDate = null;
                    }),
                    onDatePicked: _pickDate,
                    onRangePicked: _pickRange,
                    onLoadSeats: _loadSeats,
                    seatsLoaded: _seatsLoaded,
                  ),
                  if (_seatsLoaded && _dateMode == DateMode.single) ...[
                    const SizedBox(height: AppSpacing.lg),
                    SeatEditingWidget(label: _fmt(_selectedDate!)),
                  ],
                  if (_seatsLoaded && _dateMode == DateMode.range) ...[
                    const SizedBox(height: AppSpacing.lg),
                    RangePickerSection(
                      selectedRange: _selectedRange!,
                      selectedRangeDate: _selectedRangeDate,
                      onDateSelected: (d) => setState(() => _selectedRangeDate = d),
                    ),
                    if (_selectedRangeDate != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      SeatEditingWidget(label: _fmtIso(_selectedRangeDate!)),
                    ],
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const TipsSection(),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          BottomActionBar(
            onCancel: () => Navigator.pop(context),
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Changes saved.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

