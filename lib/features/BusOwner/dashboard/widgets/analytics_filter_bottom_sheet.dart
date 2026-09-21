import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedBus = 'All Buses';
  int _selectedPreset = 0;
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();

  static const _buses = ['All Buses', 'BATTI EXPRESS', 'TRIMAT', 'TST'];
  static const _presets = ['Today', 'Last 7 Days', 'Last 30 Days'];

  static const _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  static const _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFFF4F5F7),
    border: _inputBorder,
    enabledBorder: _inputBorder,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
  );

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        ctrl.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _clear() => setState(() {
        _selectedBus = 'All Buses';
        _selectedPreset = 0;
        _fromCtrl.clear();
        _toCtrl.clear();
      });

  void _apply() => Navigator.pop(context, {
        'bus': _selectedBus,
        'preset': _presets[_selectedPreset],
        'from': _fromCtrl.text,
        'to': _toCtrl.text,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Bus dropdown
          const Text(
            'Filter by Bus',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            value: _selectedBus,
            items: _buses
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) => setState(() => _selectedBus = v!),
            decoration: _inputDecoration,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            dropdownColor: AppColors.white,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Date preset chips
          Row(
            children: List.generate(_presets.length, (i) {
              final active = _selectedPreset == i;
              return Padding(
                padding: EdgeInsets.only(
                    right: i < _presets.length - 1 ? AppSpacing.sm : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedPreset = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : const Color(0xFFF4F5F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _presets[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Custom date inputs
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FROM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _fromCtrl,
                      readOnly: true,
                      onTap: () => _pickDate(_fromCtrl),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'mm/dd/yyyy',
                        hintStyle: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _toCtrl,
                      readOnly: true,
                      onTap: () => _pickDate(_toCtrl),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'mm/dd/yyyy',
                        hintStyle: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
