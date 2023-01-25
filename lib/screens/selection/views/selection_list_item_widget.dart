import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class SelectionListItemWidget extends StatelessWidget {
  final bool isSelected;
  final String name;
  final VoidCallback onTap;

  const SelectionListItemWidget(
      {Key? key,
      required this.isSelected,
      required this.name,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: isSelected ? 14.0 : 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border:
                            Border.all(width: 1.0, color: HexColors.grey20)),
                    child: Row(children: [
                      Expanded(
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 16.0, fontFamily: 'PT Root UI'))),
                      SizedBox(width: isSelected ? 10.0 : 0.0),
                      isSelected
                          ? SvgPicture.asset('assets/ic_done.svg')
                          : Container()
                    ])),
                onTap: () => onTap())));
  }
}
