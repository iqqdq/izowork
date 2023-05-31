import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class MapControlWidget extends StatelessWidget {
  final VoidCallback onZoomInTap;
  final VoidCallback onZoomOutTap;
  final VoidCallback onShowLocationTap;
  final VoidCallback? onSearchTap;

  const MapControlWidget(
      {Key? key,
      required this.onZoomInTap,
      required this.onZoomOutTap,
      required this.onShowLocationTap,
      this.onSearchTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0));

    return Container(
        width: 44.0,
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: HexColors.grey20),
            borderRadius: borderRadius),
        child: Blur(
            blur: 15.0,
            borderRadius: borderRadius,
            child: Container(
                height: 176.0,
                decoration: BoxDecoration(
                    color: HexColors.white80, borderRadius: borderRadius)),
            overlay: Column(children: [
              Expanded(
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          highlightColor: HexColors.grey20,
                          splashColor: Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0)),
                          child: SvgPicture.asset(
                            'assets/ic_plus.svg',
                            width: 44.0,
                            fit: BoxFit.none,
                          ),
                          onTap: onZoomInTap))),
              Expanded(
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          highlightColor: HexColors.grey20,
                          splashColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/ic_minus.svg',
                            width: 44.0,
                            fit: BoxFit.none,
                          ),
                          onTap: onZoomOutTap))),
              Expanded(
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          highlightColor: HexColors.grey20,
                          splashColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/ic_location.svg',
                            width: 44.0,
                            fit: BoxFit.none,
                          ),
                          onTap: onShowLocationTap))),
              onSearchTap == null
                  ? Container()
                  : Expanded(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              highlightColor: HexColors.grey20,
                              splashColor: Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0)),
                              child: SvgPicture.asset('assets/ic_search.svg',
                                  width: 44.0,
                                  fit: BoxFit.none,
                                  color: HexColors.grey50),
                              onTap: onSearchTap))),
            ])));
  }
}
