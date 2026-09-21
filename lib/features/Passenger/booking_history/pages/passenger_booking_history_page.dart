import 'package:bookmybus/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';

class PassengerBookingHistoryPage extends StatelessWidget {
  const PassengerBookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(title: 'Booking History'),
      body: Center(child: Text('Booking History Page')),
    );
  }
}
