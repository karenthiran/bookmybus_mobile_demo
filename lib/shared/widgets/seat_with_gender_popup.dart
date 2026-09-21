import 'package:flutter/material.dart';

class SeatWithGenderPopup extends StatefulWidget {
  const SeatWithGenderPopup({
    super.key,
    required this.seatNumber,
    this.initialSelected = false,
    this.onGenderSelected,
    this.onSelectionChanged,
  });

  final int seatNumber;
  final bool initialSelected;
  final ValueChanged<String>? onGenderSelected;
  final ValueChanged<bool>? onSelectionChanged;

  @override
  State<SeatWithGenderPopup> createState() => _SeatWithGenderPopupState();
}

class _SeatWithGenderPopupState extends State<SeatWithGenderPopup> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool _selected = false;
  bool _hasGender = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
    _hasGender = widget.initialSelected;
  }

  @override
  void didUpdateWidget(covariant SeatWithGenderPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      _selected = widget.initialSelected;
      _hasGender = widget.initialSelected;
    }
  }

  void _closePopup({bool forceReset = false}) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (forceReset || (!_hasGender && _selected)) {
      setState(() {
        _selected = false;
        _hasGender = false;
      });
      widget.onSelectionChanged?.call(false);
    }
  }

  void _handleSeatTap() {
    if (_overlayEntry != null) {
      return;
    }

    setState(() {
      _selected = true;
    });
    widget.onSelectionChanged?.call(true);
    _showPopup();
  }

  void _showPopup() {
    final overlay = Overlay.of(context, rootOverlay: true);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _closePopup(forceReset: true),
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topLeft,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(24, -8),
                  targetAnchor: Alignment.centerLeft,
                  followerAnchor: Alignment.centerLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ChoiceButton(
                            label: 'Male',
                            borderColor: const Color(0xFF2563EB),
                            textColor: const Color(0xFF2563EB),
                            onPressed: () {
                              _hasGender = true;
                              _selected = true;
                              widget.onGenderSelected?.call('Male');
                              setState(() {});
                              _closePopup();
                            },
                          ),
                          const SizedBox(width: 8),
                          _ChoiceButton(
                            label: 'Female',
                            borderColor: const Color(0xFFDB2777),
                            textColor: const Color(0xFFDB2777),
                            onPressed: () {
                              _hasGender = true;
                              _selected = true;
                              widget.onGenderSelected?.call('Female');
                              setState(() {});
                              _closePopup();
                            },
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 16,
                              onPressed: () => _closePopup(forceReset: true),
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final background = _selected
        ? const Color(0xFF2563EB)
        : const Color(0xFFF0FDF4);
    final borderColor = _selected
        ? const Color(0xFF2563EB)
        : const Color(0xFF4ADE80);
    final textColor = _selected ? Colors.white : const Color(0xFF0F172A);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _handleSeatTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.6),
            boxShadow: _selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '${widget.seatNumber}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.onPressed,
  });

  final String label;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
