import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class InputWidget extends StatefulWidget {
  final bool? isSearchInput;
  final EdgeInsets? margin;
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
      this.isSearchInput,
      this.margin,
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
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
        height: 44.0,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.only(left: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: HexColors.white,
            border: Border.all(
                width: _focusNode.hasFocus ? 1.0 : 0.5,
                color: _focusNode.hasFocus
                    ? HexColors.primaryDark
                    : HexColors.grey30)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _isSearchInput
              ? Image.asset('assets/ic_search.png', color: HexColors.grey30)
              : Container(),
          Expanded(
              child: TextField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
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
                        top: _focusNode.hasFocus ? 8.0 : 10.0),
                    counterText: '',
                    hintText: widget.placeholder,
                    hintStyle: _textStyle.copyWith(color: HexColors.grey30),
                    suffixIcon: _focusNode.hasFocus &&
                            _textEditingController.text.isNotEmpty
                        ? IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Image.asset('assets/ic_clear.png'),
                            onPressed: () => {
                              _textEditingController.clear(),
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
