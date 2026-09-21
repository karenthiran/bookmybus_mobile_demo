import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddBusSubmittingOverlay extends StatelessWidget {
  const AddBusSubmittingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      ),
    );
  }
}
