import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class BorderButtonWidget extends StatefulWidget {
  final String title;
  final bool? isDisabled;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const BorderButtonWidget(
      {Key? key,
      required this.title,
      this.isDisabled,
      this.margin,
      required this.onTap})
      : super(key: key);

  @override
  _BorderButtonState createState() => _BorderButtonState();
}

class _BorderButtonState extends State<BorderButtonWidget> {
  late bool _isDisabled;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();

    _isDisabled = widget.isDisabled == null
        ? false
        : widget.isDisabled!
            ? true
            : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin == null
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : widget.margin!,
        height: 40.0,
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.0,
                color: _isDisabled
                    ? Colors.transparent
                    : _isHighlighted
                        ? HexColors.primaryMain
                        : HexColors.borderButtonHighlightColor),
            borderRadius: BorderRadius.circular(12.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12.0),
                child: Center(
                    child: Text(widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.w500,
                            color: _isDisabled
                                ? HexColors.borderButtonDisableTitleColor
                                : _isHighlighted
                                    ? HexColors.primaryMain
                                    : HexColors.primaryDark))),
                onTap: _isDisabled ? null : () => widget.onTap(),
                onHighlightChanged: (value) =>
                    setState(() => _isHighlighted = value))));
  }
}
