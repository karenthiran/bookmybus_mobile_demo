import 'package:flutter/material.dart';
import 'widgets/bus_configuration_step.dart';
import 'widgets/schedule_information_step.dart';

class Step3SchedulePage extends StatelessWidget {
  const Step3SchedulePage({
    super.key,
    this.standalone = true,
    this.scheduleKey,
    this.busConfigKey,
  });

  final bool standalone;
  final GlobalKey<ScheduleInformationStepState>? scheduleKey;
  final GlobalKey<BusConfigurationStepState>? busConfigKey;

  @override
  Widget build(BuildContext context) {
    return ScheduleInformationStep(
      key: scheduleKey,
      standalone: standalone,
      busConfigKey: busConfigKey,
    );
  }
}
