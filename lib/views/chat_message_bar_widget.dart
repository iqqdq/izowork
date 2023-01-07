import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';

class ChatMessageBarWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String hintText;
  final VoidCallback? onClipTap;
  final VoidCallback onSendTap;

  const ChatMessageBarWidget(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      required this.hintText,
      this.onClipTap,
      required this.onSendTap})
      : super(key: key);

  @override
  _ChatMessageBarState createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBarWidget> {
  @override
  Widget build(BuildContext context) {
    final TextStyle _style = TextStyle(
        color: HexColors.black, fontFamily: 'PT Root UI', fontSize: 16.0);

    /// CALCULATE TEXT HEIGHT
    final size = (TextPainter(
      text: TextSpan(
        text: widget.textEditingController.text.replaceAll('\n', ''),
        style: _style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;

    final lineCount = (size.width /
                (MediaQuery.of(context).size.width -
                    (16.0 * 2 + 8.0 * 2 + 38.0 * 2 + 24.0)))
            .ceil() +
        widget.textEditingController.text.split('\n').length;

    final _textHeight = size.height * lineCount;

    return Wrap(children: [
      Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
          child: Column(children: [
            Row(children: [
              /// CLIP BUTTON
              widget.onClipTap == null
                  ? Container()
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: _textHeight,
                      width: 38.0,
                      padding: EdgeInsets.only(
                          bottom: widget.textEditingController.text.isEmpty
                              ? 0.0
                              : 2.0),
                      constraints: const BoxConstraints(
                          minHeight: 38.0, maxHeight: 90.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () => widget.onClipTap!(),
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Center(
                                        child: SvgPicture.asset(
                                            'assets/svg/ic_clip.svg',
                                            width: 38.0,
                                            height: 38.0,
                                            fit: BoxFit.scaleDown))))
                          ])),

              /// TEXT INPUT
              Expanded(
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: _textHeight,
                      constraints: const BoxConstraints(
                          minHeight: 38.0, maxHeight: 90.0),
                      decoration: BoxDecoration(
                          color: HexColors.white,
                          border:
                              Border.all(width: 1.0, color: HexColors.grey30),
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Center(
                          child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: widget.textEditingController,
                        focusNode: widget.focusNode,
                        cursorColor: HexColors.primaryDark,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            hintText: widget.hintText,
                            hintStyle: _style.copyWith(color: HexColors.grey40),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0))),
                        style: _style,
                        onChanged: (text) => setState(() {}),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                      )))),

              /// SEND MESSAGE BUTTON
              AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: _textHeight,
                  width: 38.0,
                  padding: EdgeInsets.only(
                      bottom: widget.textEditingController.text.isEmpty
                          ? 0.0
                          : 2.0),
                  constraints:
                      const BoxConstraints(minHeight: 38.0, maxHeight: 90.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () => widget.onSendTap(),
                            borderRadius: BorderRadius.circular(20.0),
                            child: Center(
                                child: SvgPicture.asset('assets/ic_send.svg',
                                    fit: BoxFit.scaleDown,
                                    width: 38.0,
                                    height: 38.0)))
                      ]))
            ])
          ]))
    ]);
  }
}
