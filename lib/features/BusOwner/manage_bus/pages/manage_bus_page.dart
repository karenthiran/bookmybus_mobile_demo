import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import '../data/dummy_manage_bus_data.dart';
import '../widgets/bus_fleet_section.dart';
import '../widgets/company_details_card.dart';

class ManageBusPage extends StatefulWidget {
  const ManageBusPage({super.key});

  @override
  State<ManageBusPage> createState() => _ManageBusPageState();
}

class _ManageBusPageState extends State<ManageBusPage> {
  @override
  Widget build(BuildContext context) {
    final buses = DummyManageBusData.buses;

    return Scaffold(
      appBar: const CommonAppBar(title: 'Manage Bus'),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xxl + AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanyDetailsCard(),
            const SizedBox(height: AppSpacing.xl),
            BusFleetSection(buses: buses),
          ],
        ),
      ),
    );
  }
}
