import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connects to the SAME Firebase project the BookMyBus website uses, so
  // that a bus-owner ID token issued here is accepted by the backend's
  // `verifyFirebaseTokenRequired` middleware. On Android this reads
  // android/app/google-services.json; on iOS it reads
  // ios/Runner/GoogleService-Info.plist. See BACKEND_INTEGRATION.md.
  await Firebase.initializeApp();

  runApp(const App());
}
