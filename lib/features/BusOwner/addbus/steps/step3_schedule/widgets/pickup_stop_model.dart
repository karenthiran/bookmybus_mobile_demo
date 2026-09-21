import 'package:flutter/material.dart';

class PickupStop {
  PickupStop({String? id})
      : id = id ?? UniqueKey().toString(),
        placeController = TextEditingController(),
        timeController = TextEditingController();

  final String id;
  final TextEditingController placeController;
  final TextEditingController timeController;

  void dispose() {
    placeController.dispose();
    timeController.dispose();
  }

  Map<String, String> toMap() => {
        'place': placeController.text.trim(),
        'time': timeController.text.trim(),
      };
}
