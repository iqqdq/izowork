import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool isSelected;

  const CheckBoxWidget({Key? key, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            color: isSelected ? HexColors.primaryMain : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
                width: isSelected ? 0.0 : 2.0,
                color:
                    isSelected ? Colors.transparent : HexColors.primaryMain)),
        child: isSelected
            ? Center(child: SvgPicture.asset('assets/ic_checkmark.svg'))
            : Container());
  }
}
