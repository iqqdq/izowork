import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

class ChatMessageBarWidget extends StatefulWidget {
  final bool? isAudio;
  final bool? isSending;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String hintText;
  final VoidCallback? onClipTap;
  final VoidCallback onSendTap;
  final VoidCallback? onRecordStarted;
  final VoidCallback? onRecordCanceled;
  final VoidCallback? onRecord;

  const ChatMessageBarWidget(
      {Key? key,
      this.isAudio,
      this.isSending,
      required this.textEditingController,
      required this.focusNode,
      required this.hintText,
      this.onClipTap,
      required this.onSendTap,
      this.onRecordStarted,
      this.onRecordCanceled,
      this.onRecord})
      : super(key: key);

  @override
  _ChatMessageBarState createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBarWidget> {
  final ScrollController _scrollController = ScrollController();
  final double _maxScroll = 120.0;
  bool _isAudio = false;
  int _seconds = 0;
  int _minutes = 0;
  Timer? _timer;
  bool _isRecording = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_seconds == 60) {
        timer.cancel();
        setState(() {
          _isRecording = false;
          _seconds = 0;
          _minutes = 0;
        });

        if (widget.onRecordCanceled != null) {
          widget.onRecord!();
        }
      } else {
        setState(() {
          _seconds++;
          _seconds = _seconds == 59 ? 0 : _seconds;
          _minutes = _seconds ~/ 60;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isAudio = widget.textEditingController.text.isNotEmpty
        ? false
        : widget.isAudio == null
            ? false
            : widget.isAudio == false
                ? false
                : true;

    final _sec =
        _seconds.toString().characters.length > 1 ? _seconds : '0$_seconds';
    final _min =
        _minutes.toString().characters.length > 1 ? _minutes : '0$_minutes';

    final TextStyle _style = TextStyle(
        color: HexColors.black, fontFamily: 'PT Root UI', fontSize: 16.0);

    /// CALCULATE TEXT HEIGHT
    final size = (TextPainter(
      text: TextSpan(
        text: widget.textEditingController.text.replaceAll('\n', ''),
        style: _style,
      ),
      // ignore: deprecated_member_use
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;

    final _opacity = _isRecording
        ? _scrollController.hasClients
            ? ((_maxScroll - _scrollController.position.pixels) / _maxScroll)
            : 1.0
        : 1.0;

    final lineCount = (size.width /
                (MediaQuery.of(context).size.width -
                    (16.0 * 2 + 8.0 * 2 + 38.0 * 2 + 24.0)))
            .ceil() +
        widget.textEditingController.text.split('\n').length;

    final _textHeight = size.height * lineCount;

    final _sendButton = Opacity(
        opacity: _opacity <= 0.0
            ? 0.0
            : _opacity >= 1.0
                ? 1.0
                : _opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _textHeight,
          width: 38.0,
          constraints: const BoxConstraints(minHeight: 42.0, maxHeight: 90.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
                onTap: widget.textEditingController.text.isEmpty
                    ? null
                    : () => widget.onSendTap(),
                child: Center(
                    child: AnimatedOpacity(
                        opacity: _isAudio
                            ? 1.0
                            : widget.textEditingController.text.isEmpty
                                ? 0.5
                                : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: SvgPicture.asset(
                          _isAudio
                              ? _isRecording
                                  ? 'assets/ic_record_selected.svg'
                                  : 'assets/ic_record.svg'
                              : 'assets/ic_send.svg',
                          fit: BoxFit.scaleDown,
                          width: 38.0,
                          height: 38.0,
                        ))))
          ]),
        ));

    return Wrap(children: [
      Stack(children: [
        Container(
            color: HexColors.white,
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
            child: Stack(children: [
              /// RECORD INDICATOR
              _isRecording
                  ? AnimatedOpacity(
                      opacity: _seconds % 2 == 0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, top: 13.0),
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: HexColors.additionalRed),
                      ))

                  /// CLIP BUTTON
                  : widget.onClipTap == null
                      ? Container()
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          height: _textHeight,
                          width: 38.0,
                          constraints: const BoxConstraints(
                              minHeight: 42.0, maxHeight: 90.0),
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
                                        'assets/ic_clip.svg',
                                        width: 38.0,
                                        height: 38.0,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ),

              _isRecording
                  ? Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 8.0),
                      child: Text('$_min:$_sec',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'PT Root UI',
                              color: HexColors.grey40)))
                  : Container(),

              /// HIDDEN RECORD BUTTON
              AnimatedOpacity(
                  opacity: _isRecording ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    widget.isSending == null
                        ? _sendButton
                        : widget.isSending == true
                            ? Transform.scale(
                                scale: 0.6,
                                child: CircularProgressIndicator(
                                    strokeWidth: 4.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        HexColors.primaryMain)))
                            : _sendButton
                  ])),

              /// DRAGGABLE BUTTON
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                widget.textEditingController.text.isNotEmpty
                    ? _sendButton
                    : Draggable<int>(
                        data: 1,
                        axis: Axis.horizontal,
                        child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0),
                        feedback: Container(),
                        childWhenDragging: Container(),
                        onDragUpdate: (details) => {
                              if (_scrollController.hasClients)
                                if (_scrollController.position.pixels <
                                    _maxScroll)
                                  {
                                    _scrollController.jumpTo(
                                        _scrollController.position.pixels +
                                            -(details.delta.dx))
                                  }
                                else
                                  {
                                    /// CANCEL RECORD AUDIO
                                    setState(() {
                                      _isRecording = false;
                                      _seconds = 0;
                                      _minutes = 0;
                                    }),
                                    _timer?.cancel(),
                                    widget.onRecordCanceled!()
                                  }
                            },
                        onDragStarted: () => {
                              /// START RECORD AUDIO
                              setState(() => _isRecording = true),
                              startTimer(),
                              widget.onRecordStarted!()
                            },
                        onDraggableCanceled: (valocity, offset) => {
                              if (_scrollController.position.pixels <
                                  _maxScroll)
                                {
                                  _timer?.cancel(),

                                  /// SEND AUDIO
                                  if (_seconds > 2)
                                    {
                                      widget.onRecord!(),
                                    }
                                }
                              else
                                {
                                  /// CANCEL RECORD AUDIO
                                  widget.onRecordCanceled!(),
                                },
                              setState(() {
                                _isRecording = false;
                                _seconds = 0;
                                _minutes = 0;
                              }),
                              _timer?.cancel(),
                            })
              ]),

              /// TEXT INPUT
              AnimatedOpacity(
                  opacity: _isRecording ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                      padding: widget.onClipTap == null
                          ? const EdgeInsets.only(right: 40.0)
                          : const EdgeInsets.symmetric(horizontal: 40.0),
                      child: _isRecording
                          ? Container(
                              constraints: const BoxConstraints(
                                  minHeight: 42.0, maxHeight: 90.0),
                              height: _textHeight,
                            )
                          : AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              height: _textHeight,
                              constraints: const BoxConstraints(
                                  minHeight: 42.0, maxHeight: 90.0),
                              decoration: BoxDecoration(
                                  color: HexColors.white,
                                  border: Border.all(
                                      width: 1.0, color: HexColors.grey30),
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Center(
                                  child: TextFormField(
                                autocorrect: false,
                                enableSuggestions: false,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: widget.textEditingController,
                                focusNode: widget.focusNode,
                                cursorColor: HexColors.primaryDark,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    hintText: widget.hintText,
                                    hintStyle: _style.copyWith(
                                        color: HexColors.grey40),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0.0))),
                                style: _style,
                                onChanged: (text) => setState(() {}),
                                onEditingComplete: () =>
                                    FocusScope.of(context).unfocus(),
                              ))))),
            ])),

        /// SCROLLABLE CHILD
        _isRecording
            ? SingleChildScrollView(
                controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(width: MediaQuery.of(context).size.width - 152.0),
                  Opacity(
                      opacity: _opacity <= 0.0
                          ? 0.0
                          : _opacity >= 1.0
                              ? 1.0
                              : _opacity,
                      child: Row(children: [
                        SvgPicture.asset(
                          'assets/ic_arrow_cancel.svg',
                          fit: BoxFit.scaleDown,
                          colorFilter: _isRecording
                              ? null
                              : const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.srcIn,
                                ),
                        ),
                        const SizedBox(width: 8.0),
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            Titles.cancel,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'PT Root UI',
                              color: _isRecording
                                  ? HexColors.grey50
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                      ])),
                  _sendButton,
                  const SizedBox(height: 60.0, width: 152.0),
                ]))
            : Container(),
      ])
    ]);
  }
}
