import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class ScrollToEndButtonWidget extends StatelessWidget {
  final int count;
  final bool isHidden;
  final VoidCallback onTap;

  const ScrollToEndButtonWidget(
      {Key? key,
      required this.count,
      required this.isHidden,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: isHidden ? 0.0 : 1.0,
        child: SizedBox(
            width: 40.0,
            height: 50.0,
            child: Stack(children: [
              Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: HexColors.white,
                      border: Border.all(width: 0.5, color: HexColors.grey40),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: SvgPicture.asset(
                                  'assets/ic_arrow_down.svg',
                                  width: 12.0,
                                  height: 4.0,
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  color: HexColors.black)),
                          onTap: () => onTap()))),
              count == 0
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Badge(
                        backgroundColor: Colors.red,
                        child: Text(count.toString(),
                            style: const TextStyle(color: Colors.white)),
                      ))
            ])));
  }
}
