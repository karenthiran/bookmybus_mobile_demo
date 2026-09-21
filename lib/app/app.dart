import 'package:bookmybus/features/Passenger/passenger_main_page.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyBus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PassengerMainPage(),
    );
  }
}
