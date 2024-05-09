import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class BottomButtonWidget extends StatelessWidget {
  final String title;
  final EdgeInsets? margin;
  final bool? isDisabled;
  final VoidCallback onTap;

  const BottomButtonWidget(
      {Key? key,
      required this.title,
      this.margin,
      this.isDisabled,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDisabled = isDisabled == null
        ? false
        : isDisabled!
            ? true
            : false;

    return Container(
        height: 50.0 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
            color: _isDisabled ? HexColors.grey20 : HexColors.primaryMain),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.primaryDark,
                splashColor: Colors.transparent,
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom),
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold,
                                color: _isDisabled
                                    ? HexColors.grey40
                                    : HexColors.black)))),
                onTap: _isDisabled ? null : () => onTap())));
  }
}
