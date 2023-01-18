import 'package:hexcolor/hexcolor.dart';

abstract class HexColors {
  /// CLASSIC
  static var black = HexColor("#000000");
  static var white = HexColor("#FFFFFF");

  /// BACKGROUND
  static var opacity90 = grey.withOpacity(0.9);
  static var opcaity70 = grey.withOpacity(0.7);
  static var overlay = black.withOpacity(0.6);

  /// PRIMARY
  static var primaryDark = HexColor("#A7C100");
  static var primaryMain = HexColor("#C8E320");
  static var primaryLight = HexColor("#296ACC");

  /// SECONDARY
  static var secondaryDark = primaryDark.withOpacity(0.45);
  static var secondaryMain = primaryMain.withOpacity(0.3);
  static var secondaryLight = primaryLight.withOpacity(0.1);

  /// ADDITIONAL
  static var additionalRed = HexColor("#CB2A2A");
  static var additionalOrange = HexColor("#FFA048");
  static var additionalYellow = HexColor("#FFF27E");
  static var additionalGreen = HexColor("#00BC8E");
  static var additionalBlue = HexColor("#2EFFF2");
  static var additionalDeepBlue = HexColor("#4664FF");
  static var additionalViolet = HexColor("#7C5BFF");
  static var additionalVioletLight = HexColor("#F6F4FF");
  static var additionalPink = HexColor("#FF49AB");

  /// GREY
  static var grey = HexColor("#F5F5F5");
  static var grey10 = HexColor("#F0F0ED");
  static var grey20 = HexColor("#E0E0DE");
  static var grey30 = HexColor("#C7C7C5");
  static var grey40 = HexColor("#ADADAC");
  static var grey50 = HexColor("#949492");
  static var grey70 = HexColor("#616160");
  static var grey80 = HexColor("#474747");
  static var grey90 = HexColor("#2E2E2D");

  /// WHITE
  static var white90 = white.withOpacity(0.9);
  static var white80 = white.withOpacity(0.8);
  static var white70 = white.withOpacity(0.7);
  static var white60 = white.withOpacity(0.6);
  static var white50 = white.withOpacity(0.5);
  static var white40 = white.withOpacity(0.4);
  static var white30 = white.withOpacity(0.3);
  static var white20 = white.withOpacity(0.2);
  static var white10 = white.withOpacity(0.1);

  /// SHADOW
  static var card = black.withOpacity(0.05);

  /// BUTTON
  static var shadowButtonHighlightColor = HexColor("#EEEEEE");
  static var shadowButtonDisableColor = white.withOpacity(0.3);
  static var shadowButtonDisableTitleColor = HexColor("#BDBDC7");
  static var borderButtonHighlightColor = secondaryDark.withOpacity(0.6);
  static var borderButtonDisableTitleColor = HexColor("#D7D7E0");

  /// CHART
  static var lightPinkColor = HexColor("#F0C9CC");
  static var darkBlueColor = HexColor("#241F45");
  static var pinkColor = HexColor("#EA3958");
  static var blueColor = HexColor("#3F799C");
  static var turquoiseColor = HexColor("#83BFB3");
}
