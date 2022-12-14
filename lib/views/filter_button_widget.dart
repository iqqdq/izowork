import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/shadows.dart';
import 'package:izowork/components/titles.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onClearTap;

  const FilterButtonWidget({Key? key, required this.onTap, this.onClearTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            height: 38.0,
            decoration: BoxDecoration(
                color: HexColors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [Shadows.shadow]),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 12.0, right: onClearTap == null ? 12.0 : 0.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(children: [
                                Image.asset('assets/ic_filter.png'),
                                const SizedBox(width: 10.0),
                                Text(Titles.filter,
                                    style: TextStyle(
                                        color: HexColors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.w500)),
                              ]),
                              SizedBox(
                                  height: 38.0,
                                  child: onClearTap == null
                                      ? Container()
                                      : InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.asset(
                                              'assets/ic_clear.png'),
                                          onTap: () => onClearTap!()))
                            ])),
                    onTap: () => onTap()))));
  }
}
