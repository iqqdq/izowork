import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  final bool? isSearchInput;
  final EdgeInsets? margin;
  final double? height;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Color? backgroundColor;
  final String? placeholder;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClearTap;

  const InputWidget(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.isSearchInput,
      this.margin,
      this.height,
      this.textInputType,
      this.textInputAction,
      this.textCapitalization,
      this.backgroundColor,
      this.placeholder,
      this.onTap,
      this.onChange,
      this.onEditingComplete,
      this.onClearTap})
      : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    final _isSearchInput = widget.isSearchInput == null
        ? false
        : widget.isSearchInput == true
            ? true
            : false;

    final _textStyle = TextStyle(
        fontFamily: 'PT Root UI',
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: HexColors.black);

    return Container(
        height: widget.height ?? 44.0,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.only(left: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: HexColors.white,
            border: Border.all(
                width: widget.focusNode.hasFocus ? 1.0 : 0.5,
                color: widget.focusNode.hasFocus
                    ? HexColors.primaryDark
                    : HexColors.grey30)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _isSearchInput
              ? Image.asset('assets/ic_search.png', color: HexColors.grey30)
              : Container(),
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
                    contentPadding: EdgeInsets.only(
                        left: _isSearchInput ? 10.0 : 0.0,
                        top: widget.focusNode.hasFocus ? 8.0 : 10.0),
                    counterText: '',
                    hintText: widget.placeholder,
                    hintStyle: _textStyle.copyWith(color: HexColors.grey30),
                    suffixIcon: widget.focusNode.hasFocus &&
                            widget.textEditingController.text.isNotEmpty
                        ? IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Image.asset('assets/ic_clear.png'),
                            onPressed: () => {
                              widget.textEditingController.clear(),
                              widget.onClearTap,
                              widget.onClearTap == null
                                  ? null
                                  : widget.onClearTap!()
                            },
                          )
                        : IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Image.asset('assets/ic_clear.png',
                                color: Colors.transparent),
                            onPressed: () => {}),
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
                          }))
        ]));
  }
}
