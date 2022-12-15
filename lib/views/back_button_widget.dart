import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class BackButtonWidget extends StatefulWidget {
  final String? title;
  final VoidCallback onTap;

  const BackButtonWidget({
    Key? key,
    this.title,
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
          Image.asset('assets/ic_back_arrow.png',
              color: HexColors.primaryDark, width: 24.0, height: 24.0),
          SizedBox(width: widget.title == null ? 0.0 : 4.0),
          widget.title == null
              ? Container()
              : Text('text',
                  style: TextStyle(
                      color: _isHighlight
                          ? HexColors.secondaryDark
                          : HexColors.primaryDark,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.w400))
        ]),
        onHighlightChanged: (value) => setState(() => _isHighlight = value),
        onTap: () => widget.onTap());
  }
}
