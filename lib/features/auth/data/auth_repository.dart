import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import 'company_profile.dart';

/// Handles bus-owner authentication.
///
/// The BookMyBus backend authenticates every request using a Firebase ID
/// token (see server/middlewares/firebaseAuth.js), exactly like the
/// existing React website (client/src/pages/busOwner/CompanyLogin.jsx):
///   1. Sign in with Firebase Auth (email + password).
///   2. Call `GET /api/companies/me` with the ID token to load the
///      company profile tied to that Firebase account.
class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Signs in with email/password and returns the matching company
  /// profile. Throws [ApiException] with a user-friendly message on
  /// failure (bad credentials, no company for this account, etc).
  Future<CompanyProfile> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw ApiException(_mapFirebaseError(e));
    }

    try {
      final json = await ApiClient.instance.get('/companies/me');
      if (json is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }
      return CompanyProfile.fromJson(json);
    } on ApiException catch (e) {
      // If there is no company profile for this Firebase account, the
      // sign-in itself succeeded but this user isn't a registered bus
      // owner. Sign them back out so the app doesn't hold a "half"
      // session, matching the website's behaviour.
      await _firebaseAuth.signOut();
      if (e.statusCode == 404) {
        throw ApiException(
          'No company profile found for this account. Please contact support.',
        );
      }
      rethrow;
    }
  }

  /// Loads the company profile for whichever Firebase user is currently
  /// signed in. Used on app start-up to restore an existing session
  /// without asking the user to log in again.
  Future<CompanyProfile> fetchCurrentCompany() async {
    if (_firebaseAuth.currentUser == null) {
      throw ApiException('Not signed in.');
    }
    final json = await ApiClient.instance.get('/companies/me');
    if (json is! Map<String, dynamic>) {
      throw ApiException('Unexpected response from server.');
    }
    return CompanyProfile.fromJson(json);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }
}
