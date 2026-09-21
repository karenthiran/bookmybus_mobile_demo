# Connecting the BookMyBus mobile app to the BookMyBus website backend

This app talks to your Render backend at:

```
https://bookmybus-qubitz-demo.onrender.com/api
```

exactly the same way your website (`client/src/api/*.js`) does — including
using **Firebase Authentication** for login, because your backend's
`server/middlewares/firebaseAuth.js` only accepts a Firebase ID token.

## What's wired up now

| Screen                                                  | Status                                                       |
| ------------------------------------------------------- | ------------------------------------------------------------ |
| Bus-owner Login                                         | ✅ Real Firebase sign-in + `/companies/me`                   |
| App startup (session restore)                           | ✅ Auto-restores session if already signed in                |
| Dashboard (stats, charts, top routes/buses)             | ✅ Real `/companies/dashboard-stats`                         |
| Manage Bus (fleet list + company card)                  | ✅ Real `/companies/buses` + `/companies/me`                 |
| Sign out                                                | ✅ Profile page → logout icon                                |
| Add Bus / Manage Seats / Booking History / Call Booking | ⏳ Still using local/dummy data — see "Extending this" below |
| Passenger side                                          | Untouched — separate feature area, not part of this pass     |

## The one thing you must do yourself: Firebase config

I can't generate your Firebase project's secret keys — you need to pull them
from the **same Firebase project your website already uses** (so that a
bus-owner who logs into the app is recognized by the same backend as one who
logs into the website).

### Android

1. Go to the [Firebase console](https://console.firebase.google.com) → your BookMyBus project → Project settings → your apps.
2. Add an Android app (if not already added) with package name `com.example.bookmybus` (or update `android/app/build.gradle.kts` → `applicationId` to match an existing registered app).
3. Download `google-services.json` and place it at `android/app/google-services.json`.
4. That's it — the Gradle plugin wiring is already in place in this delivery (`android/settings.gradle.kts`, `android/app/build.gradle.kts`).

### iOS

1. In the same Firebase project, add an iOS app with your bundle ID (`ios/Runner.xcodeproj` → check `PRODUCT_BUNDLE_IDENTIFIER`).
2. Download `GoogleService-Info.plist`.
3. Open `ios/Runner.xcworkspace` in Xcode and drag the file into the `Runner` folder, making sure "Copy items if needed" and the `Runner` target are checked. (This step needs Xcode; it can't be done as a plain text-file edit.)

### Then

```bash
flutter pub get
flutter run
```

No Dart code needs to change once those two files are in place — `main.dart`
already calls `Firebase.initializeApp()`.

## How the pieces fit together

- `lib/core/config/api_config.dart` — the backend base URL (already set for you).
- `lib/core/network/api_client.dart` — every request goes through here; it
  automatically attaches `Authorization: Bearer <Firebase ID token>`.
- `lib/core/session/app_session.dart` — holds the signed-in company's profile
  in memory (`ChangeNotifier`, wired at the root of the app in `lib/app/app.dart`).
- `lib/app/auth_gate.dart` — the app's real entry point. Shows `LoginPage` when
  signed out, `OperatorDashboardScreen` when signed in.
- `lib/features/auth/data/auth_repository.dart` — sign-in / sign-out / restore session.
- `lib/features/BusOwner/dashboard/data/dashboard_repository.dart` — dashboard stats.
- `lib/features/BusOwner/manage_bus/data/manage_bus_repository.dart` — fleet list.

## Extending this to the remaining screens

The pattern is the same every time:

1. Add a `<feature>_repository.dart` in that feature's `data/` folder that
   calls `ApiClient.instance.get/post/put/delete('/path', ...)` and maps the
   JSON into that feature's existing model classes (don't change the models —
   the widgets already expect them).
2. In the page's `State`, replace the dummy-data reference with a
   `Future`/`FutureBuilder` (see `manage_bus_page.dart` or
   `operator_dashboard_screen.dart` for the exact shape to copy) with
   loading / error / empty states.
3. Reuse `context.watch<AppSession>().company` wherever you need the current
   company's id/name/email.

Relevant backend endpoints already in your server for the remaining screens:

- **Add Bus**: `POST /api/buses` (`server/controllers/busController.js` → `createBus`). Note this screen also uploads bus photos to Cloudinary directly from the client (see `client/src/...` for how the website does it) — fill in `ApiConfig.cloudinaryCloudName` / `cloudinaryUploadPreset` from your website's `.env` first.
- **Edit/Delete Bus**: `PUT /api/buses/company/:id`, `DELETE /api/buses/company/:id`.
- **Manage Seats**: seat-hold/seat-release endpoints under `server/routes/seatHoldRoutes.js` and the relevant `companyController` seat endpoints.
- **Booking History**: `GET /api/companies/bookings` (see `client/src/api/company.js` for the exact query params the website already sends).
- **Call Booking**: `server/routes/busOwnerCallBooking` / `client/src/api/busOwnerCallBooking.js` — mirrors 1:1 into a new `call_booking_repository.dart`.
- **Profile edit** (address, contact person, additional contacts): the backend's `GET/PUT /api/companies/me` today only returns `companyName`, `email`, `contactNo`, `addressString`. The extra fields currently on the Profile page (contact person, website, city/province/postal breakdown, additional contacts) aren't in that response yet — either extend the backend's `Company` model/controller first, or drop those fields from the UI.

## Known limitations of this pass

- Passenger-side screens are untouched.
- No image upload wired yet (Add Bus screen needs Cloudinary credentials, see above).
- No token refresh edge-case beyond what `firebase_auth` already handles automatically.
- Everything was written and reasoned through against your actual backend
  routes/controllers, but **not compiled** in this environment (no Flutter
  SDK / no network access to pub.dev here) — run `flutter analyze` after
  `flutter pub get` and let me know if anything needs fixing.
