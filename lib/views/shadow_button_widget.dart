import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

class ShadowButtonWidget extends StatefulWidget {
  final String title;
  final bool? isDisabled;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const ShadowButtonWidget(
      {Key? key,
      required this.title,
      this.isDisabled,
      this.margin,
      required this.onTap})
      : super(key: key);

  @override
  _ShadowButtonState createState() => _ShadowButtonState();
}

class _ShadowButtonState extends State<ShadowButtonWidget> {
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
            color: _isDisabled
                ? HexColors.shadowButtonDisableColor
                : HexColors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: _isDisabled ? [] : [Shadows.shadow]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.shadowButtonHighlightColor,
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
                                ? HexColors.shadowButtonDisableTitleColor
                                : _isHighlighted
                                    ? HexColors.primaryMain
                                    : HexColors.primaryDark))),
                onTap: _isDisabled ? null : () => widget.onTap(),
                onHighlightChanged: (value) =>
                    setState(() => _isHighlighted = value))));
  }
}
