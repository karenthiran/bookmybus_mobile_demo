import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'pickup_stop_model.dart';

class PickupDropPoints extends StatefulWidget {
  const PickupDropPoints({
    super.key,
    this.onChanged,
    this.startPlace,
    this.startTime,
    this.endPlace,
    this.endTime,
    this.intermediateStops = const [],
  });

  /// Returns ordered list of all stops [start, ...intermediate, end].
  final ValueChanged<List<Map<String, String>>>? onChanged;

  /// Pre-populated start/end values (read-only, platform-controlled).
  final String? startPlace;
  final String? startTime;
  final String? endPlace;
  final String? endTime;

  /// Pre-populated intermediate stops as [{place, time}, ...].
  final List<Map<String, String>> intermediateStops;

  @override
  State<PickupDropPoints> createState() => _PickupDropPointsState();
}

class _PickupDropPointsState extends State<PickupDropPoints> {
  late final PickupStop _start;
  late final PickupStop _end;
  late final List<PickupStop> _intermediate;

  @override
  void initState() {
    super.initState();
    _start = PickupStop(id: 'start')
      ..placeController.text = widget.startPlace ?? ''
      ..timeController.text = widget.startTime ?? '';
    _end = PickupStop(id: 'end')
      ..placeController.text = widget.endPlace ?? ''
      ..timeController.text = widget.endTime ?? '';
    _intermediate = widget.intermediateStops.map((m) {
      final s = PickupStop();
      s.placeController.text = m['place'] ?? '';
      s.timeController.text = m['time'] ?? '';
      return s;
    }).toList();
  }

  @override
  void dispose() {
    _start.dispose();
    _end.dispose();
    for (final s in _intermediate) {
      s.dispose();
    }
    super.dispose();
  }

  void _addStop() {
    setState(() => _intermediate.add(PickupStop()));
    _notify();
  }

  void _removeStop(int index) {
    setState(() => _intermediate.removeAt(index)..dispose());
    _notify();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _intermediate.removeAt(oldIndex);
      _intermediate.insert(newIndex, item);
    });
    _notify();
  }

  void _notify() {
    widget.onChanged?.call([
      _start.toMap(),
      ..._intermediate.map((s) => s.toMap()),
      _end.toMap(),
    ]);
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      controller.text = picked.format(context);
      _notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────
        Row(
          children: [
            Text('Intermediate Pickup Points', style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.section,
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                'optional',
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _AddStopButton(onTap: _addStop),
        const SizedBox(height: AppSpacing.lg),

        // ── Start Stop ────────────────────────────────────────────
        _FixedStopCard(
          label: 'Start (From)',
          accentColor: AppColors.success,
          icon: Icons.trip_origin_rounded,
          stop: _start,
          readOnly: true,
          onTimeTap: () => _pickTime(_start.timeController),
        ),

        // ── Timeline connector ────────────────────────────────────
        _TimelineConnector(
          child: _intermediate.isEmpty
              ? _EmptyIntermediateHint(onAdd: _addStop)
              : _DraggableList(
                  stops: _intermediate,
                  onReorder: _onReorder,
                  onRemove: _removeStop,
                  onTimeTap: (c) => _pickTime(c),
                  onChanged: _notify,
                ),
        ),

        // ── End Stop ──────────────────────────────────────────────
        _FixedStopCard(
          label: 'End (To)',
          accentColor: AppColors.error,
          icon: Icons.location_on_rounded,
          stop: _end,
          readOnly: true,
          onTimeTap: () => _pickTime(_end.timeController),
        ),

        // ── Add Button (also shown above list) ─────────────────────────────
        if (_intermediate.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _AddStopButton(onTap: _addStop),
        ],
      ],
    );
  }
}

// ── Fixed Stop Card ───────────────────────────────────────────────────────────

class _FixedStopCard extends StatelessWidget {
  const _FixedStopCard({
    required this.label,
    required this.accentColor,
    required this.icon,
    required this.stop,
    required this.onTimeTap,
    this.readOnly = false,
  });

  final String label;
  final Color accentColor;
  final IconData icon;
  final PickupStop stop;
  final VoidCallback onTimeTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accentColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md - 1)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 14, color: accentColor),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: tt.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (readOnly)
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.lock_outline_rounded,
                              size: 10, color: accentColor),
                        ),
                      Text(
                        readOnly ? 'Platform controlled' : 'Fixed',
                        style: tt.bodyMedium?.copyWith(
                          color: accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Fields
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: readOnly
                ? _ReadOnlyStopFields(stop: stop)
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _StopField(
                          controller: stop.placeController,
                          hint: 'Type location...',
                          icon: Icons.place_outlined,
                          required: true,
                          onChanged: (_) {},
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: _TimeField(
                          controller: stop.timeController,
                          onTap: onTimeTap,
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

// ── Read-Only Stop Fields ──────────────────────────────────────────────

class _ReadOnlyStopFields extends StatelessWidget {
  const _ReadOnlyStopFields({required this.stop});
  final PickupStop stop;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _ReadOnlyItem(
            label: 'Place',
            value: stop.placeController.text.isEmpty
                ? '—'
                : stop.placeController.text,
            tt: tt,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 2,
          child: _ReadOnlyItem(
            label: 'Time',
            value: stop.timeController.text.isEmpty
                ? '—'
                : stop.timeController.text,
            tt: tt,
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyItem extends StatelessWidget {
  const _ReadOnlyItem(
      {required this.label, required this.value, required this.tt});
  final String label;
  final String value;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodySmall
              ?.copyWith(color: AppColors.textHint, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Draggable Intermediate List ───────────────────────────────────────────────

class _DraggableList extends StatelessWidget {
  const _DraggableList({
    required this.stops,
    required this.onReorder,
    required this.onRemove,
    required this.onTimeTap,
    required this.onChanged,
  });

  final List<PickupStop> stops;
  final void Function(int, int) onReorder;
  final void Function(int) onRemove;
  final void Function(TextEditingController) onTimeTap;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stops.length, (index) {
        final stop = stops[index];
        return _IntermediateStopCard(
          key: ValueKey(stop.id),
          index: index,
          total: stops.length,
          stop: stop,
          onMoveUp: index > 0 ? () => onReorder(index, index - 1) : null,
          onMoveDown:
              index < stops.length - 1 ? () => onReorder(index, index + 2) : null,
          onRemove: () => onRemove(index),
          onTimeTap: () => onTimeTap(stop.timeController),
          onChanged: onChanged,
        );
      }),
    );
  }
}

// ── Intermediate Stop Card ────────────────────────────────────────────────────

class _IntermediateStopCard extends StatelessWidget {
  const _IntermediateStopCard({
    super.key,
    required this.index,
    required this.total,
    required this.stop,
    required this.onRemove,
    required this.onTimeTap,
    required this.onChanged,
    this.onMoveUp,
    this.onMoveDown,
  });

  final int index;
  final int total;
  final PickupStop stop;
  final VoidCallback onRemove;
  final VoidCallback onTimeTap;
  final VoidCallback onChanged;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.sm, AppSpacing.sm, 0),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: tt.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Pickup #${index + 1}',
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                // Move up
                _ReorderBtn(
                  icon: Icons.keyboard_arrow_up_rounded,
                  enabled: onMoveUp != null,
                  onTap: onMoveUp,
                ),
                // Move down
                _ReorderBtn(
                  icon: Icons.keyboard_arrow_down_rounded,
                  enabled: onMoveDown != null,
                  onTap: onMoveDown,
                ),
                const SizedBox(width: AppSpacing.xs),
                // Delete
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delete_outline_rounded,
                            size: 13, color: AppColors.error),
                        const SizedBox(width: 3),
                        Text(
                          'Delete',
                          style: tt.labelSmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Fields row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm,
                AppSpacing.md, AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'Place', required: true),
                      const SizedBox(height: AppSpacing.xs),
                      _StopField(
                        controller: stop.placeController,
                        hint: 'Type location...',
                        icon: Icons.place_outlined,
                        onChanged: (_) => onChanged(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'Time', required: true),
                      const SizedBox(height: AppSpacing.xs),
                      _TimeField(
                        controller: stop.timeController,
                        onTap: onTimeTap,
                      ),
                    ],
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

class _ReorderBtn extends StatelessWidget {
  const _ReorderBtn(
      {required this.icon, required this.enabled, required this.onTap});
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primary : AppColors.textDisabled,
        ),
      ),
    );
  }
}

// ── Timeline Connector ────────────────────────────────────────────────────────

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 2, height: 12, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: Container(width: 2, color: const Color(0xFFE2E8F0)),
              ),
              Container(width: 2, height: 12, color: const Color(0xFFE2E8F0)),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty Hint ────────────────────────────────────────────────────────────────

class _EmptyIntermediateHint extends StatelessWidget {
  const _EmptyIntermediateHint({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
              color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_location_alt_outlined,
                size: 22, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'No intermediate pickup points added.',
              style: tt.bodyMedium?.copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
            Text(
              'Tap to add one.',
              style: tt.bodyMedium?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Stop Button ───────────────────────────────────────────────────────────

class _AddStopButton extends StatelessWidget {
  const _AddStopButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.primary.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '+ Add Pickup Point',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Field Label ──────────────────────────────────────────────────────────────

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
          style: tt.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        if (required)
          Text(' *',
              style: tt.bodySmall
                  ?.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Shared Input Widgets ──────────────────────────────────────────────────────

class _StopField extends StatelessWidget {
  const _StopField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.required = false,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool required;
  final ValueChanged<String> onChanged;

  static const _fill = Color(0xFFF8FAFC);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.textHint, fontSize: 13),
        prefixIcon: Icon(icon, size: 16, color: AppColors.textHint),
        filled: true,
        fillColor: _fill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.controller, required this.onTap});
  final TextEditingController controller;
  final VoidCallback onTap;

  static const _fill = Color(0xFFF8FAFC);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: '--:--',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textHint, fontSize: 13),
            suffixIcon: const Icon(Icons.access_time_rounded,
                size: 16, color: AppColors.textHint),
            filled: true,
            fillColor: _fill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
