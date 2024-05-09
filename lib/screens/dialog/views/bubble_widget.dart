import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/screens/dialog/views/date_header_widget.dart';
import 'package:izowork/api/api.dart';

class BubbleWidget extends StatefulWidget {
  final bool animate;
  final bool isMine;
  final bool isRead;
  final bool isAudio;
  final bool isFile;
  final bool isDownloading;
  final double? verticalSpacing;
  final bool showName;
  final bool isGroupLastMessage;
  final User? user;
  final String text;
  final bool showDate;
  final DateTime dateTime;
  final VoidCallback? onUserTap;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BubbleWidget(
      {Key? key,
      required this.isMine,
      required this.isRead,
      required this.showName,
      required this.isFile,
      required this.isDownloading,
      required this.isAudio,
      required this.isGroupLastMessage,
      required this.animate,
      this.verticalSpacing,
      this.user,
      required this.text,
      required this.showDate,
      required this.dateTime,
      this.onUserTap,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<BubbleWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;
  int _position = 0;
  int? _duration;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
        value: widget.animate ? 0.0 : 1.0);

    super.initState();

    // APPEREANCE ANIMATION
    if (_animationController.value == 0.0) {
      _animationController.forward();
    }

    // INIT AUDIO PLAYER
    if (widget.isAudio && widget.text.isNotEmpty) {
      _initAudioPlayer();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future _initAudioPlayer() async {
    if (Platform.isIOS) {
      const AudioContext audioContext = AudioContext(
          iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
        options: [
          AVAudioSessionOptions.defaultToSpeaker,
          AVAudioSessionOptions.mixWithOthers,
        ],
      ));

      AudioPlayer.global.setGlobalAudioContext(audioContext);
    }

    _audioPlayer = AudioPlayer();
    _audioPlayer?.setSourceUrl(widget.text);

    _audioPlayer?.onDurationChanged.listen((event) {
      setState(() => _duration = event.inSeconds);
    });

    _audioPlayer?.onPositionChanged.listen((event) {
      setState(() => _position = event.inSeconds);
    });

    _audioPlayer?.onPlayerStateChanged.listen(
      (it) {
        switch (it) {
          case PlayerState.completed:
            setState(() => _isPlaying = false);
            break;
          case PlayerState.playing:
            setState(() => _isPlaying = true);
            break;
          case PlayerState.paused:
            setState(() => _isPlaying = true);
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var curr = 1.0 - (1.0 / _position);
    curr = curr > 0 ? curr : 0.25;

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

    // final size = Text('16.5 MB',
    //     style: TextStyle(
    //         fontSize: 12.0,
    //         fontFamily: 'PT Root UI',
    //         color: widget.isMine
    //             ? HexColors.white.withOpacity(0.6)
    //             : HexColors.black.withOpacity(0.6)));

    final current = Text(
        _position.toString().length > 1
            ? '00:${_position.toString()}'
            : '00:0${_position.toString()}',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final total = Text(
        _duration.toString().length > 1
            ? '00:${_duration.toString()}'
            : '00:0${_duration.toString()}',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final contentList = ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        /// USERNAME
        widget.isMine
            ? Container()
            : widget.showName
                ? GestureDetector(
                    onTap: widget.onUserTap == null
                        ? null
                        : () => widget.onUserTap!(),
                    child: Text(widget.user?.name ?? '',
                        style: TextStyle(
                            color: HexColors.grey40,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold)))
                : Container(),
        SizedBox(height: widget.showName ? 4.0 : 0.0),

        /// AUDIO
        widget.isAudio
            ? _duration == null && _duration == 0 || Platform.isIOS
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [current])
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        current,
                        _duration == null ? Container() : total
                      ])
            : text,
        SizedBox(height: widget.isAudio ? 0.0 : 2.0),

        /// FILE
        widget.isFile
            // ? size
            ? Container()
            : _audioPlayer != null
                ? IgnorePointer(
                    ignoring: Platform.isIOS,
                    child: SizedBox(
                        height: 36.0,
                        child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                                value: Platform.isIOS
                                    ? _position == 0
                                        ? 0.0
                                        : curr
                                    : _position.toDouble(),
                                min: 0.0,
                                max: Platform.isIOS
                                    ? 1.0
                                    : _duration?.toDouble() ?? 1.0,
                                thumbColor: widget.isMine
                                    ? HexColors.white
                                    : HexColors.additionalViolet,
                                activeColor: widget.isMine
                                    ? HexColors.white.withOpacity(0.75)
                                    : HexColors.additionalViolet
                                        .withOpacity(0.75),
                                inactiveColor: widget.isMine
                                    ? HexColors.white.withOpacity(0.3)
                                    : HexColors.additionalViolet
                                        .withOpacity(0.3),
                                onChanged: (value) => {
                                      _audioPlayer?.seek(
                                          Duration(seconds: value.toInt()))
                                    }))))
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
            margin: EdgeInsets.only(bottom: widget.verticalSpacing ?? 0.0),
            child: Container(
                margin: EdgeInsets.only(
                    bottom: widget.isMine ? 2.0 : 10.0,
                    left: widget.isMine ? _sidePadding : 0.0,
                    right: widget.isMine ? 0.0 : _sidePadding),
                padding: widget.isFile || widget.isAudio
                    ? EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 8.0,
                        top: widget.isFile ? 16.0 : 12.0)
                    : const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: widget.isMine
                      ? HexColors.additionalViolet
                      : HexColors.white,
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
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(children: [
                              widget.isDownloading
                                  ?
                                  // Show indicator
                                  Transform.scale(
                                      scale: 0.75,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 6.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            widget.isMine
                                                ? HexColors.white
                                                : HexColors.additionalViolet,
                                          )))
                                  // Show file icon
                                  : SvgPicture.asset(
                                      'assets/ic_dialog_file.svg',
                                      color: widget.isMine
                                          ? HexColors.white
                                          : HexColors.additionalViolet,
                                      width: 40.0,
                                      height: 40.0),
                              const SizedBox(width: 10.0),
                              Expanded(child: contentList)
                            ]),
                            SizedBox(
                                height: !widget.isMine && widget.isFile
                                    ? 8.0
                                    : 0.0),
                            time
                          ])
                    : _audioPlayer != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () => setState(() {
                                              _isPlaying
                                                  ? _audioPlayer?.pause()
                                                  : _audioPlayer?.resume();
                                              _isPlaying = !_isPlaying;
                                            }),
                                        child: _audioPlayer == null
                                            ? Container()
                                            : SvgPicture.asset(
                                                _isPlaying
                                                    ? 'assets/ic_dialog_pause.svg'
                                                    : 'assets/ic_dialog_play.svg',
                                                color: widget.isMine
                                                    ? HexColors.white
                                                    : HexColors
                                                        .additionalViolet,
                                                width: 40.0,
                                                height: 40.0,
                                                fit: BoxFit.cover)),
                                    const SizedBox(width: 10.0),
                                    Expanded(child: contentList)
                                  ],
                                ),
                                time
                              ])
                        : Column(children: [
                            contentList,
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: widget.isMine
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              children: [
                                widget.isMine
                                    ? widget.isRead
                                        ? SvgPicture.asset('assets/ic_read.svg')
                                        : SvgPicture.asset(
                                            'assets/ic_unread.svg')
                                    : Container(),
                                time
                              ],
                            )
                          ]))));

    final gestureDetector = GestureDetector(
      onTap: widget.onTap == null ? null : () => widget.onTap!(),
      onLongPress:
          widget.onLongPress == null ? null : () => widget.onLongPress!(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget.isMine
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(bottom: 20.0, right: 8.0),
                  child: widget.isGroupLastMessage
                      ?

                      /// AVATAR
                      GestureDetector(
                          onTap: widget.onUserTap == null
                              ? null
                              : () => widget.onUserTap!(),
                          child: Stack(children: [
                            SvgPicture.asset('assets/ic_avatar.svg',
                                color: HexColors.grey40,
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover),
                            widget.user == null
                                ? Container()
                                : widget.user!.avatar == null
                                    ? Container()
                                    : widget.user!.avatar!.isEmpty
                                        ? Container()
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                                cacheKey: widget.user!.avatar,
                                                imageUrl: avatarUrl +
                                                    widget.user!.avatar!,
                                                width: 24.0,
                                                height: 24.0,
                                                memCacheWidth: 24 *
                                                    MediaQuery.of(context)
                                                        .devicePixelRatio
                                                        .round(),
                                                fit: BoxFit.cover)),
                          ]))
                      : SizedBox(width: widget.user == null ? 0.0 : 24.0),
                ),
          Expanded(child: bubble)
        ],
      ),
    );

    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          widget.showDate
              ? DateHeaderWidget(
                  dateTime: DateTime(
                    widget.dateTime.year,
                    widget.dateTime.month,
                    widget.dateTime.day,
                  ),
                  child: gestureDetector)
              : gestureDetector
        ]);
  }
}
