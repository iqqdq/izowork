import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class LabelInputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String labelText;
  final double? height;
  final EdgeInsets? margin;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final String? placeholder;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClearTap;

  const LabelInputWidget({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.labelText,
    this.height,
    this.margin,
    this.textInputType,
    this.textInputAction,
    this.textCapitalization,
    this.placeholder,
    this.onTap,
    this.onChange,
    this.onEditingComplete,
    this.onClearTap,
  }) : super(key: key);

  @override
  _LabelInputState createState() => _LabelInputState();
}

class _LabelInputState extends State<LabelInputWidget> {
  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(
      fontFamily: 'PT Root UI',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: HexColors.black,
    );

    return Container(
        height: widget.height ?? 56.0,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 4.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: HexColors.white,
            border: Border.all(
                width: widget.focusNode.hasFocus ? 1.0 : 0.5,
                color: widget.focusNode.hasFocus
                    ? HexColors.primaryDark
                    : HexColors.grey30)),
        child: Row(children: [
          Expanded(
              child: TextField(
                  controller: widget.textEditingController,
                  focusNode: widget.focusNode,
                  keyboardAppearance: Brightness.light,
                  keyboardType: widget.textInputType ?? TextInputType.text,
                  cursorColor: HexColors.primaryDark,
                  textInputAction:
                      widget.textInputAction ?? TextInputAction.done,
                  textCapitalization:
                      widget.textCapitalization ?? TextCapitalization.sentences,
                  style: _textStyle,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: _textStyle.copyWith(color: HexColors.grey40),
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                    hintText: widget.placeholder,
                    hintStyle: _textStyle.copyWith(color: HexColors.grey30),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onTap: widget.onTap == null ? null : () => widget.onTap!(),
                  onChanged: widget.onChange == null
                      ? null
                      : (text) => {setState, widget.onChange!(text)},
                  onEditingComplete: widget.onEditingComplete == null
                      ? () => FocusScope.of(context).unfocus()
                      : () => {
                            widget.onEditingComplete!(),
                            FocusScope.of(context).unfocus()
                          })),
          widget.textEditingController.text.isEmpty ||
                  !widget.focusNode.hasFocus
              ? Container()
              : IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: SvgPicture.asset('assets/ic_clear.svg',
                      width: 24.0, height: 24.0, fit: BoxFit.cover),
                  onPressed: () => setState(() {
                        widget.textEditingController.clear();
                        widget.onClearTap;
                        widget.onClearTap == null ? null : widget.onClearTap!();
                      }))
        ]));
  }
}
