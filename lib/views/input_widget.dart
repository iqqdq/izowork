import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final bool? isSearchInput;
  final bool? obscureText;
  final EdgeInsets? margin;
  final double? height;
  final int? maxLines;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Color? backgroundColor;
  final String? placeholder;
  final VoidCallback? onTap;
  final Function(String)? onChange;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClearTap;

  const InputWidget({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    this.isSearchInput,
    this.obscureText,
    this.margin,
    this.height,
    this.maxLines,
    this.textInputType,
    this.textInputAction,
    this.textCapitalization,
    this.backgroundColor,
    this.placeholder,
    this.onTap,
    this.onChange,
    this.onEditingComplete,
    this.onClearTap,
  }) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  void dispose() {
    FocusScope.of(context).unfocus();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _maxLines = widget.maxLines ?? 1;

    final _isSearchInput = widget.isSearchInput == null
        ? false
        : widget.isSearchInput == true
            ? true
            : false;

    final _textStyle = TextStyle(
      fontFamily: 'PT Root UI',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: HexColors.black,
    );

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
                : HexColors.grey30,
          )),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _maxLines > 1
            ? Container()
            : _isSearchInput
                ? SvgPicture.asset(
                    'assets/ic_search.svg',
                    colorFilter: ColorFilter.mode(
                      HexColors.grey30,
                      BlendMode.srcIn,
                    ),
                  )
                : Container(),
        Expanded(
          child: TextField(
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              maxLines: widget.maxLines ?? 1,
              obscureText: widget.obscureText ?? false,
              enableSuggestions: false,
              autocorrect: false,
              keyboardAppearance: Brightness.light,
              keyboardType: widget.textInputType ?? TextInputType.text,
              cursorColor: HexColors.primaryDark,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.sentences,
              style: _textStyle,
              decoration: InputDecoration(
                contentPadding: _maxLines > 1
                    ? const EdgeInsets.only(
                        left: 10.0,
                        top: 14.0,
                        bottom: 14.0,
                      )
                    : EdgeInsets.only(
                        left: _isSearchInput ? 10.0 : 0.0,
                        top: _isSearchInput ? 6.0 : 2.0,
                      ),
                counterText: '',
                labelText: _isSearchInput ? null : widget.placeholder,
                hintText: _isSearchInput ? widget.placeholder : null,
                labelStyle: _textStyle.copyWith(color: HexColors.grey30),
                suffixIconConstraints: BoxConstraints(
                  maxWidth: widget.focusNode.hasFocus &&
                          widget.textEditingController.text.isNotEmpty &&
                          widget.onClearTap != null
                      ? 44.0
                      : 16.0,
                ),
                suffixIcon: widget.focusNode.hasFocus &&
                        widget.textEditingController.text.isNotEmpty &&
                        widget.onClearTap != null
                    ? IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: SvgPicture.asset(
                          'assets/ic_clear.svg',
                          width: 16.0,
                          height: 16.0,
                        ),
                        onPressed: () => {
                          widget.textEditingController.clear(),
                          setState(() {
                            widget.onClearTap == null
                                ? null
                                : widget.onClearTap!();
                          })
                        },
                      )
                    : Container(),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onTap: widget.onTap == null ? null : () => widget.onTap!(),
              onChanged: (text) => {
                    setState(() {
                      if (widget.onChange != null) widget.onChange!(text);
                    }),
                  },
              onEditingComplete: widget.onEditingComplete == null
                  ? () => FocusScope.of(context).unfocus()
                  : () => {
                        FocusScope.of(context).unfocus(),
                        widget.focusNode.unfocus(),
                      }),
        ),
      ]),
    );
  }
}
