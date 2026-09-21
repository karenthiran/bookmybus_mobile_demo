import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const card = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const button = [
    BoxShadow(
      color: Color(0x2200236F),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}