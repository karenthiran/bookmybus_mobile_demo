import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_radius.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

import '../models/add_bus_data.dart';
import '../steps/step1_upload_images/step1_upload_images_page.dart';
import '../steps/step2_basic_info/step2_basic_info_page.dart';
import '../steps/step3_schedule/step3_schedule_page.dart';
import '../steps/step3_schedule/widgets/bus_configuration_step.dart';
import '../steps/step3_schedule/widgets/schedule_information_step.dart';
import '../widgets/add_bus_submitting_overlay.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({super.key});

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  bool _isSubmitting = false;

  final _step2Key = GlobalKey<Step2BasicInfoPageState>();
  final _scheduleKey = GlobalKey<ScheduleInformationStepState>();
  final _busConfigKey = GlobalKey<BusConfigurationStepState>();

  AddBusData _collectData() => AddBusData();

  Future<void> _onSubmit() async {
    final step2Valid = _step2Key.currentState?.validate() ?? false;
    final scheduleValid = _scheduleKey.currentState?.validate() ?? false;
    final configValid = _busConfigKey.currentState?.validate() ?? false;
    if (!step2Valid || !scheduleValid || !configValid) return;

    setState(() => _isSubmitting = true);

    try {
      final busData = _collectData();

      // TODO: ADD BACKEND CODE HERE
      // Example:
      //   final response = await BusRepository().addBus(busData.toJson());
      //   if (response.success) { ... }

      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackbar(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.xxl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 36,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Bus Added Successfully!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your bus has been submitted and is pending review.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.white, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Failed to add bus. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: const CommonAppBar(title: 'Add Bus'),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Step1UploadImagesPage(standalone: false),
                      const Divider(height: 1),
                      Step2BasicInfoPage(key: _step2Key, standalone: false),
                      const Divider(height: 1),
                      Step3SchedulePage(
                        standalone: false,
                        scheduleKey: _scheduleKey,
                        busConfigKey: _busConfigKey,
                      ),
                    ],
                  ),
                ),
              ),
              _SubmitBar(onSubmit: _onSubmit),
            ],
          ),
          if (_isSubmitting) const AddBusSubmittingOverlay(),
        ],
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.onSubmit});
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 18),
              SizedBox(width: AppSpacing.xs),
              Text('Add Bus to System'),
            ],
          ),
        ),
      ),
    );
  }
}
