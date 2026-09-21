import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TimelineDot extends StatelessWidget {
  const TimelineDot({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 4),
        ],
      ),
    );
  }
}
