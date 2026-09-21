import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/session/app_session.dart';
import 'auth_gate.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppSession(),
      child: MaterialApp(
        title: 'BookMyBus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // This app is the bus-owner side of BookMyBus, so it opens straight
        // into the sign-in flow / operator dashboard rather than the
        // passenger UI. See lib/features/Passenger for the passenger-side
        // screens, still available to wire up under their own entry point.
        home: const AuthGate(),
      ),
    );
  }
}
