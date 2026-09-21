import 'package:flutter/material.dart';
import 'step_indicator.dart';
import 'step_nav_bar.dart';

class AddBusStepContent extends StatelessWidget {
  const AddBusStepContent({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.stepView,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final List<({String label, IconData icon})> steps;
  final int currentStep;
  final Widget stepView;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepIndicator(steps: steps, currentStep: currentStep),
        Expanded(child: stepView),
        StepNavBar(
          currentStep: currentStep,
          totalSteps: steps.length,
          onBack: onBack,
          onNext: onNext,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}
