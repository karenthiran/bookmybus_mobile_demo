import 'package:flutter/foundation.dart';

import '../../features/auth/data/company_profile.dart';

/// Holds the currently signed-in bus-owner's company profile in memory so
/// any screen (dashboard, manage bus, add bus, profile...) can read the
/// companyId / companyName without re-fetching it every time.
///
/// This is intentionally simple (a ChangeNotifier, not a full state
/// management library) so it drops into the existing widget tree with a
/// single `ChangeNotifierProvider` in `app.dart`.
class AppSession extends ChangeNotifier {
  CompanyProfile? _company;

  CompanyProfile? get company => _company;

  bool get isSignedIn => _company != null;

  void setCompany(CompanyProfile company) {
    _company = company;
    notifyListeners();
  }

  void clear() {
    _company = null;
    notifyListeners();
  }
}
