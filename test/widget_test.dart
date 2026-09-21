import 'package:bookmybus/features/BusOwner/CallBooking/models/call_booking_model.dart';
import 'package:bookmybus/features/BusOwner/CallBooking/steps/step2_seats_page.dart';
import 'package:bookmybus/features/BusOwner/addbus/pages/add_bus_page.dart';
import 'package:bookmybus/features/BusOwner/dashboard/pages/operator_dashboard_screen.dart';
import 'package:bookmybus/features/BusOwner/Profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Step 2 shows the trip banner and the seat selection contract', (WidgetTester tester) async {
    final trip = CallBusTripModel(
      busName: 'THEUEU',
      busNumber: 'E454P',
      departureTime: '00:33',
      from: 'Trincomalee',
      to: 'Colombo',
      pricePerSeat: 1500,
      seatsLeft: 45,
    );

    final booking = CallBookingModel(
      travelDate: DateTime(2026, 9, 1),
      selectedTrip: trip,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Step2SeatsPage(
          booking: booking,
          onChanged: () {},
        ),
      ),
    );

    expect(find.text('THEUEU · Trincomalee → Colombo · 00:33'), findsOneWidget);
    expect(find.text('Select Seats (max 10)'), findsOneWidget);
    expect(find.text('Available'), findsWidgets);
    expect(find.text('Booked (M)'), findsOneWidget);
    expect(find.text('Booked (F)'), findsOneWidget);
  });

  testWidgets('Dashboard header profile icon navigates to the profile screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OperatorDashboardScreen(),
      ),
    );

    expect(find.byIcon(Icons.person_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
  });

  testWidgets('Bottom navigation includes all required features and navigates to Add Bus',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OperatorDashboardScreen(),
      ),
    );

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Add Bus'), findsOneWidget);
    expect(find.text('Manage Buses'), findsOneWidget);
    expect(find.text('Booking History'), findsOneWidget);
    expect(find.text('Call Booking'), findsOneWidget);

    await tester.tap(find.text('Add Bus'));
    await tester.pumpAndSettle();

    expect(find.byType(AddBusPage), findsOneWidget);
  });
}
