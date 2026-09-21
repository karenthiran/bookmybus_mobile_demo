import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      titleSpacing: 15,
       elevation: 10,
      title: Row(
        children: [
          Image.asset(
            'assets/images/bus-logo.png',
            height: 40,
            width: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: AppSpacing.sm),
        
        ],
      ),
    );
  }
}
