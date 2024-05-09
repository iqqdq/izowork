import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';

class BackButtonWidget extends StatefulWidget {
  final String? title;
  final String? asset;
  final VoidCallback onTap;

  const BackButtonWidget({
    Key? key,
    this.title,
    this.asset,
    required this.onTap,
  }) : super(key: key);

  @override
  _BackButtonState createState() => _BackButtonState();
}

class _BackButtonState extends State<BackButtonWidget> {
  bool _isHighlight = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(children: [
          SvgPicture.asset(widget.asset ?? 'assets/ic_back_arrow.svg',
              color: widget.asset == null
                  ? _isHighlight
                      ? HexColors.secondaryDark
                      : HexColors.primaryDark
                  : null,
              width: 24.0,
              height: 24.0),
          SizedBox(width: widget.title == null ? 0.0 : 4.0),
          widget.title == null
              ? Container()
              : Text(widget.title!,
                  style: TextStyle(
                      color: _isHighlight
                          ? HexColors.secondaryDark
                          : HexColors.primaryDark,
                      fontSize: 16.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold))
        ]),
        onHighlightChanged: (value) => setState(() => _isHighlight = value),
        onTap: () => widget.onTap());
  }
}
