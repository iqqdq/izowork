import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';

class SortObjectButtonWidget extends StatefulWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const SortObjectButtonWidget(
      {Key? key,
      required this.title,
      required this.imagePath,
      required this.onTap})
      : super(key: key);

  @override
  _SortObjectButtonState createState() => _SortObjectButtonState();
}

class _SortObjectButtonState extends State<SortObjectButtonWidget> {
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            onHighlightChanged: (value) =>
                setState(() => _isHighlighted = value),
            child: Row(children: [
              Text(widget.title,
                  style: TextStyle(
                      color:
                          _isHighlighted ? HexColors.grey80 : HexColors.grey50,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI')),
              const SizedBox(width: 8.0),
              widget.imagePath.isEmpty
                  ? Container()
                  : SvgPicture.asset(
                      widget.imagePath,
                      colorFilter: _isHighlighted
                          ? ColorFilter.mode(
                              HexColors.grey80,
                              BlendMode.srcIn,
                            )
                          : null,
                    )
            ]),
            onTap: () => widget.onTap()));
  }
}
