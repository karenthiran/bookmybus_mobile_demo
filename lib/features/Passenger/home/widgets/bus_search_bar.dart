import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:flutter/material.dart';

class BusSearchBar extends StatelessWidget {
  const BusSearchBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search city or bus...',
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIcon:
            const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
        ),
      ),
    );
  }
}
