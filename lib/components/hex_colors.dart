import 'package:hexcolor/hexcolor.dart';

abstract class HexColors {
  /// CLASSIC
  static var white = HexColor("#FFFFFF");
  static var white80 = HexColor("#FFFFFF").withOpacity(0.8);

  static var black = HexColor("#000000");

  /// PRIMARY
  static var primaryDark = HexColor("#A7C100");
  static var primaryMain = HexColor("#C8E320");
  static var primaryLight = HexColor("#296ACC");

  /// GRAY
  static var gray = HexColor("#F5F5F5");
  static var gray10 = HexColor("#F0F0ED");
  static var gray20 = HexColor("#E0E0DE");
  static var gray30 = HexColor("#C7C7C5");
  static var gray40 = HexColor("#ADADAC");
  static var gray50 = HexColor("#949492");
  static var gray70 = HexColor("#616160");
}
