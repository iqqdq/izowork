import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

abstract class Shadows {
  static var shadow = BoxShadow(
      offset: const Offset(0.0, 10.0), blurRadius: 20.0, color: HexColors.card);
  static var calendarEventShadow = BoxShadow(
      offset: const Offset(0.0, 2.0), blurRadius: 4.0, color: HexColors.card);
}
