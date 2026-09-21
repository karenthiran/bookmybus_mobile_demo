import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    required this.selectedCount,
    required this.totalFare,
  });

  final int selectedCount;
  final double totalFare;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Select Seats (max 10)',
            style: tt.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${selectedCount == 0 ? 0 : selectedCount} selected · LKR ${totalFare.toStringAsFixed(0)}',
          style: tt.titleSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
