import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

const _yellow = Color(0xFFB45309);
const _yellowBg = Color(0xFFFFFBEB);
const _yellowBorder = Color(0xFFFCD34D);
const _yellowSelected = Color(0xFFF59E0B);

/// Mock permanently-blocked seats – replace with real data source.
const _permanentlyBlockedSeats = [
  34, 15, 16, 19, 20, 23, 24, 27, 28, 32, 33, 35, 36, 39, 40, 41, 42, 43, 44, 45, 14
];

Future<Map<String, dynamic>?> showReleaseSeatsDialog(BuildContext context) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _ReleaseSeatsDialog(),
  );
}

class _ReleaseSeatsDialog extends StatefulWidget {
  const _ReleaseSeatsDialog();

  @override
  State<_ReleaseSeatsDialog> createState() => _ReleaseSeatsDialogState();
}

class _ReleaseSeatsDialogState extends State<_ReleaseSeatsDialog> {
  late Set<int> _selected;
  DateTime? _from;
  DateTime? _to;
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set.from(_permanentlyBlockedSeats);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _from = picked;
        if (_to != null && _to!.isBefore(picked)) _to = null;
      });
    }
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _to ?? (_from ?? DateTime.now()),
      firstDate: _from ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _to = picked);
  }

  bool get _canConfirm => _selected.isNotEmpty && _from != null && _to != null;

  void _confirm() {
    if (!_canConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select seats and a valid date range.')),
      );
      return;
    }
    Navigator.pop(context, {
      'seats': _selected.toList(),
      'from': _from,
      'to': _to,
      'reason': _reasonController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _permanentlyBlockedSeats.length;
    final count = _selected.length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────
            _DialogHeader(onClose: () => Navigator.pop(context)),
            const Divider(height: 1, color: AppColors.border),
            // ── Scrollable body ──────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: _yellowBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _yellowBorder),
                      ),
                      child: const Text(
                        'Select which permanently-blocked seats to make bookable during the chosen date range. Deselect any seats you want to keep blocked.',
                        style: TextStyle(fontSize: 13, color: _yellow),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Select Seats ─────────────────────────────────
                    const _Label(text: 'Select Seats to Release'),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _TextBtn(
                          label: 'Select All',
                          onTap: () => setState(() =>
                              _selected = Set.from(_permanentlyBlockedSeats)),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _TextBtn(
                          label: 'Clear All',
                          onTap: () => setState(() => _selected.clear()),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _permanentlyBlockedSeats.map((seat) {
                        final sel = _selected.contains(seat);
                        return GestureDetector(
                          onTap: () => setState(() => sel
                              ? _selected.remove(seat)
                              : _selected.add(seat)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel ? _yellowSelected : AppColors.section,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: sel ? _yellowBorder : AppColors.border,
                                width: sel ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$seat',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: sel
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '$count of $total seats selected for release.',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _yellow),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Release Date Range ───────────────────────────
                    const _Label(text: 'Release Date Range'),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _DatePickerField(
                            label: 'Release From',
                            value: _from != null ? _fmt(_from!) : null,
                            onTap: _pickFrom,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          child: Text('→',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary)),
                        ),
                        Expanded(
                          child: _DatePickerField(
                            label: 'Release To',
                            value: _to != null ? _fmt(_to!) : null,
                            onTap: _pickTo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Reason ───────────────────────────────────────
                    const _Label(text: 'Reason (Optional)'),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _reasonController,
                      maxLines: 3,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter reason for temporary release...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: AppColors.textHint),
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: _yellowSelected),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            // ── Actions ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _canConfirm ? _yellowSelected : AppColors.section,
                        foregroundColor:
                            _canConfirm ? AppColors.white : AppColors.textHint,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: _canConfirm
                                  ? _yellowBorder
                                  : AppColors.border),
                        ),
                      ),
                      child: Text(
                        'Release $count Seat${count == 1 ? '' : 's'}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.sm, AppSpacing.lg),
      child: Row(
        children: [
          const Text('🔓', style: TextStyle(fontSize: 20)),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Text(
              'Release Seats Temporarily',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _TextBtn extends StatelessWidget {
  const _TextBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField(
      {required this.label, required this.value, required this.onTap});
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(
              color: value != null ? _yellowBorder : AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: value != null ? _yellowBg : AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? 'MM/DD/YYYY',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 15, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
