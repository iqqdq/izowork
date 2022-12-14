import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class MapControlWidget extends StatelessWidget {
  final VoidCallback onZoomInTap;
  final VoidCallback onZoomOutTap;
  final VoidCallback onShowLocationTap;
  final VoidCallback onSearchTap;

  const MapControlWidget(
      {Key? key,
      required this.onZoomInTap,
      required this.onZoomOutTap,
      required this.onShowLocationTap,
      required this.onSearchTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0));

    return Container(
      padding: const EdgeInsets.only(left: 1.0, top: 1.0, bottom: 1.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: HexColors.gray20),
          borderRadius: borderRadius),
      child: Blur(
          blur: 15.0,
          borderRadius: borderRadius,
          child: Container(
            width: 44.0,
            height: 176.0,
            decoration: BoxDecoration(
                color: HexColors.white80, borderRadius: borderRadius),
          ),
          overlay: Column(children: [
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0)),
                        child: Image.asset('assets/ic_plus.png'),
                        onTap: onZoomInTap))),
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        child: Image.asset('assets/ic_minus.png'),
                        onTap: onZoomOutTap))),
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        child: Image.asset('assets/ic_location.png'),
                        onTap: onShowLocationTap))),
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0)),
                        child: Image.asset('assets/ic_search.png'),
                        onTap: onSearchTap))),
          ])),
    );
  }
}
