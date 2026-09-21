import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CallBookingLoadingOverlay extends StatelessWidget {
  const CallBookingLoadingOverlay({
    super.key,
    required this.isVisible,
  });

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.35),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      ),
    );
  }
}
