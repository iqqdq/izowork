import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class BorderButtonWidget extends StatefulWidget {
  final String title;
  final double? height;
  final bool? isDestructive;
  final bool? isDisabled;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const BorderButtonWidget({
    Key? key,
    required this.title,
    this.height,
    this.isDestructive,
    this.isDisabled,
    this.margin,
    required this.onTap,
  }) : super(key: key);

  @override
  _BorderButtonState createState() => _BorderButtonState();
}

class _BorderButtonState extends State<BorderButtonWidget> {
  late bool _isDisabled;
  late bool _isDestructive;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();

    _isDestructive = widget.isDestructive == null
        ? false
        : widget.isDestructive!
            ? true
            : false;

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
      height: widget.height ?? 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: _isDisabled
              ? Colors.transparent
              : _isHighlighted
                  ? _isDestructive
                      ? HexColors.additionalRed
                      : HexColors.primaryDark
                  : _isDestructive
                      ? HexColors.additionalRed.withOpacity(0.5)
                      : HexColors.borderButtonHighlightColor,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          child: Center(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w500,
                color: _isDisabled
                    ? HexColors.borderButtonDisableTitleColor
                    : _isHighlighted
                        ? _isDestructive
                            ? HexColors.additionalRed
                            : HexColors.primaryDark
                        : _isDestructive
                            ? HexColors.additionalRed.withOpacity(0.75)
                            : HexColors.primaryDark,
              ),
            ),
          ),
          onTap: _isDisabled ? null : () => widget.onTap(),
          onHighlightChanged: (value) => setState(() => _isHighlighted = value),
        ),
      ),
    );
  }
}
