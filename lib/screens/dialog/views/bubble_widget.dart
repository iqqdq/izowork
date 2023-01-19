import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/screens/dialog/views/date_header_widget.dart';

class BubbleWidget extends StatefulWidget {
  final bool isMine;
  final bool isFile;
  final bool isAudio;
  final bool isGroupLastMessage;
  final bool animate;
  final EdgeInsets? margin;
  final String text;
  final bool showDate;
  final DateTime dateTime;
  final VoidCallback? onLongPress;

  const BubbleWidget(
      {Key? key,
      required this.isMine,
      required this.isFile,
      required this.isAudio,
      required this.isGroupLastMessage,
      required this.animate,
      this.margin,
      required this.text,
      required this.showDate,
      required this.dateTime,
      this.onLongPress})
      : super(key: key);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<BubbleWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  double _audioTime = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
        value: widget.animate ? 0.0 : 1.0);

    if (_animationController.value == 0.0) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _sidePadding =
        MediaQuery.of(context).size.width * (widget.isMine ? 0.25 : 0.1);

    /// FORMAT TIME
    final _hour = widget.dateTime.hour.toString().length < 2
        ? '0${widget.dateTime.hour.toString()}'
        : widget.dateTime.hour.toString();
    final _minute = widget.dateTime.minute.toString().length < 2
        ? '0${widget.dateTime.minute.toString()}'
        : widget.dateTime.minute.toString();

    /// MESSAGE CONTENT
    final text = Text(widget.text,
        textAlign: TextAlign.start,
        maxLines: widget.isFile ? 1 : null,
        style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final time = Align(
        alignment: widget.isMine ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Text(_hour + ':' + _minute,
            style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'PT Root UI',
                color: widget.isMine
                    ? HexColors.white.withOpacity(0.6)
                    : HexColors.black.withOpacity(0.6))));

    final size = Text('16.5 MB',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine
                ? HexColors.white.withOpacity(0.6)
                : HexColors.black.withOpacity(0.6)));

    final current = Text('00:00',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final total = Text('00:50',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final contentList = ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        widget.isAudio
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [current, total])
            : text,
        SizedBox(height: widget.isAudio ? 0.0 : 2.0),
        widget.isFile
            ? size
            : widget.isAudio
                ? SizedBox(
                    height: 36.0,
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                            value: _audioTime,
                            thumbColor: widget.isMine
                                ? HexColors.white
                                : HexColors.additionalViolet,
                            activeColor: widget.isMine
                                ? HexColors.white.withOpacity(0.75)
                                : HexColors.additionalViolet.withOpacity(0.75),
                            inactiveColor: widget.isMine
                                ? HexColors.white.withOpacity(0.3)
                                : HexColors.additionalViolet.withOpacity(0.3),
                            onChanged: (value) =>
                                setState(() => _audioTime = value))))
                : Container()
      ],
    );

    /// BUBBLE
    final bubble = SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
        axisAlignment: -1,
        child: Container(
            margin: widget.margin ??
                EdgeInsets.only(
                    bottom: widget.isMine ? 6.0 : 10.0,
                    left: widget.isMine ? _sidePadding : 0.0,
                    right: widget.isMine ? 0.0 : _sidePadding),
            padding: widget.isFile || widget.isAudio
                ? EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                    top: widget.isFile ? 16.0 : 12.0)
                : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color:
                  widget.isMine ? HexColors.additionalViolet : HexColors.white,
              boxShadow: widget.isMine
                  ? null
                  : [
                      BoxShadow(
                          color: HexColors.black.withOpacity(0.05),
                          blurRadius: 4.0,
                          offset: const Offset(0.0, 4.0))
                    ],
              borderRadius: widget.isMine
                  ? widget.isGroupLastMessage
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.zero,
                          bottomLeft: Radius.circular(20.0))
                      : BorderRadius.circular(20.0)
                  : widget.isGroupLastMessage
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.zero)
                      : BorderRadius.circular(20.0),
            ),
            child: widget.isFile
                ? Column(children: [
                    Row(children: [
                      SvgPicture.asset('assets/ic_dialog_file.svg',
                          color: widget.isMine
                              ? HexColors.white
                              : HexColors.additionalViolet,
                          width: 40.0,
                          height: 40.0),
                      const SizedBox(width: 10.0),
                      Expanded(child: contentList)
                    ]),
                    const SizedBox(height: 4.0),
                    time
                  ])
                : widget.isAudio
                    ? Column(children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/ic_dialog_play.svg',
                                color: widget.isMine
                                    ? HexColors.white
                                    : HexColors.additionalViolet,
                                width: 40.0,
                                height: 40.0),
                            const SizedBox(width: 10.0),
                            Expanded(child: contentList)
                          ],
                        ),
                        time
                      ])
                    : Column(
                        children: [
                          contentList,
                          const SizedBox(height: 4.0),
                          time
                        ],
                      )));

    final gestureDetector = GestureDetector(
      onLongPress: widget.onLongPress,
      child: bubble,
    );

    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          widget.showDate
              ? DateHeaderWidget(
                  dateTime: DateTime(widget.dateTime.year,
                      widget.dateTime.month, widget.dateTime.day),
                  child: gestureDetector)
              : gestureDetector
        ]);
  }
}
