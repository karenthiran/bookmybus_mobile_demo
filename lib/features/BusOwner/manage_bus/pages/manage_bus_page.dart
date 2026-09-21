import 'package:bookmybus/app/theme/app_colors.dart';
import 'package:bookmybus/app/theme/app_spacing.dart';
import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/session/app_session.dart';
import '../data/manage_bus_repository.dart';
import '../models/manage_bus_model.dart';
import '../widgets/bus_fleet_section.dart';
import '../widgets/company_details_card.dart';

class ManageBusPage extends StatefulWidget {
  const ManageBusPage({super.key});

  @override
  State<ManageBusPage> createState() => _ManageBusPageState();
}

class _ManageBusPageState extends State<ManageBusPage> {
  final _repository = ManageBusRepository();
  late Future<List<BusFleetModel>> _busesFuture;

  @override
  void initState() {
    super.initState();
    _busesFuture = _repository.fetchBuses();
  }

  Future<void> _refresh() async {
    final future = _repository.fetchBuses();
    setState(() => _busesFuture = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final company = context.watch<AppSession>().company;

    return Scaffold(
      appBar: const CommonAppBar(title: 'Manage Bus'),
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxl + AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyDetailsCard(
                companyName: company?.companyName ?? '—',
                companyEmail: company?.email ?? '—',
              ),
              const SizedBox(height: AppSpacing.xl),
              FutureBuilder<List<BusFleetModel>>(
                future: _busesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    final message = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : 'Could not load your buses. Pull down to retry.';
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_off_outlined,
                              size: 36, color: AppColors.textHint),
                          const SizedBox(height: AppSpacing.sm),
                          Text(message, textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  }

                  final buses = snapshot.data ?? const [];
                  return BusFleetSection(buses: buses);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
