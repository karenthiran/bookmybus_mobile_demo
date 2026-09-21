import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/api_exception.dart';
import '../core/session/app_session.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/company_profile.dart';
import '../features/auth/login/login_page.dart';
import '../features/BusOwner/dashboard/pages/operator_dashboard_screen.dart';

/// App entry point for the bus-owner side.
///
/// Listens to Firebase's own auth state so that:
///  - a signed-out user always sees [LoginPage]
///  - a signed-in user sees [OperatorDashboardScreen], after we've loaded
///    (or confirmed we already hold) their [AppSession.company] profile.
///
/// This means [LoginPage] itself never has to `Navigator.push` anywhere —
/// once `AuthRepository.signIn` succeeds, Firebase emits a new auth state,
/// this widget rebuilds, and the dashboard appears automatically.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScaffold();
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        final session = context.watch<AppSession>();
        if (session.company != null) {
          return const OperatorDashboardScreen();
        }

        // We have a Firebase session (e.g. app was reopened) but haven't
        // loaded the matching company profile into memory yet.
        return _RestoreCompanySession(
          onRestored: (company) => context.read<AppSession>().setCompany(company),
        );
      },
    );
  }
}

class _RestoreCompanySession extends StatefulWidget {
  const _RestoreCompanySession({required this.onRestored});

  final void Function(CompanyProfile company) onRestored;

  @override
  State<_RestoreCompanySession> createState() =>
      _RestoreCompanySessionState();
}

class _RestoreCompanySessionState extends State<_RestoreCompanySession> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final company = await AuthRepository().fetchCurrentCompany();
      if (!mounted) return;
      widget.onRestored(company);
    } on ApiException catch (e) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      setState(() => _error = 'Something went wrong. Please sign in again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      // Signing out above will make AuthGate's StreamBuilder rebuild into
      // LoginPage on the next frame; show the reason in the meantime.
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!, textAlign: TextAlign.center),
          ),
        ),
      );
    }
    return const _LoadingScaffold();
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
