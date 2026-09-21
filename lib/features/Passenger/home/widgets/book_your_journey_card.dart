import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_shadows.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BookYourJourneyCard extends StatefulWidget {
  const BookYourJourneyCard({super.key});

  @override
  State<BookYourJourneyCard> createState() => _BookYourJourneyCardState();
}

class _BookYourJourneyCardState extends State<BookYourJourneyCard> {
  String? _departure;
  String? _destination;
  String _travelDate = '09/09/2026';

  static const _cities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Mannar',
    'Jaffna',
    'Trincomalee',
    'Anuradhapura',
    'Kurunegala',
    'Matara',
    'Negombo',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 9, 9),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _travelDate =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.luggage, color: Colors.cyan, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Book your journey',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Departure dropdown ───────────────────────────────────
          _DropdownField(
            label: 'Departure from',
            value: _departure,
            items: _cities,
            onChanged: (v) => setState(() => _departure = v),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Destination dropdown ─────────────────────────────────
          _DropdownField(
            label: 'Destination to',
            value: _destination,
            items: _cities,
            onChanged: (v) => setState(() => _destination = v),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Travel date picker ───────────────────────────────────
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Travel date',
                          style: tt.bodySmall
                              ?.copyWith(color: AppColors.textHint, fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _travelDate,
                          style: tt.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined,
                      color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Search button ────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 20),
              label: const Text('Search buses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md + 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dropdown Field ─────────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: tt.bodySmall?.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
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
      ),
      items: items
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
