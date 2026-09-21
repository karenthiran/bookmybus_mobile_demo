import '../models/bus_route_model.dart';

class DummyBusRouteData {
  DummyBusRouteData._();

  static const List<BusRouteModel> routes = [
    BusRouteModel(
      from: 'Mannar',
      to: 'Colombo',
      operatorName: 'AKR EXPRESS',
      busType: 'Luxury',
      frequency: 'Daily',
      departureHour: 0,
      departureMinute: 0,
    ),
    BusRouteModel(
      from: 'Colombo',
      to: 'Kandy',
      operatorName: 'LION EXPRESS',
      busType: 'Super Luxury',
      frequency: 'Daily',
      departureHour: 6,
      departureMinute: 30,
    ),
    BusRouteModel(
      from: 'Galle',
      to: 'Colombo',
      operatorName: 'SOUTHERN LINE',
      busType: 'Luxury',
      frequency: 'Daily',
      departureHour: 7,
      departureMinute: 0,
    ),
    BusRouteModel(
      from: 'Jaffna',
      to: 'Colombo',
      operatorName: 'NORTHERN STAR',
      busType: 'Super Luxury',
      frequency: 'Daily',
      departureHour: 20,
      departureMinute: 0,
    ),
  ];

  static const List<String> cities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Mannar',
    'Jaffna',
    'Trincomalee',
    'Anuradhapura',
    'Kurunegala',
    'Matara',
    'Negombo',
  ];
}
