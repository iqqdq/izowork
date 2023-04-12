// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/screens/dialog/views/date_header_widget.dart';
import 'package:izowork/services/urls.dart';
import 'package:just_audio/just_audio.dart';

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
  AudioPlayer? _player;
  int _position = 0;

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
    if (widget.isAudio) {
      _player = AudioPlayer();
      _player!.setUrl(widget.text, preload: true);

      // LISTEN PLAYER POSITION
      _player!.positionStream.listen((state) {
        if (mounted) {
          setState(() {
            _position = _player?.position.inSeconds ?? 0;
          });
        }
      });

      // LISTEN PLAYER STATE
      _player!.playerStateStream.listen((state) {
        switch (state.processingState) {
          case ProcessingState.idle:
            break;
          case ProcessingState.loading:
            break;
          case ProcessingState.buffering:
            break;
          case ProcessingState.ready:
            if (mounted) {
              setState(() => _position = _player?.position.inSeconds ?? 0);
            }
            break;
          case ProcessingState.completed:
            // RELOAD PLAYER POSITION
            if (mounted) {
              _player?.stop().then((value) => _player
                  ?.seek(const Duration(seconds: 0))
                  .then((value) => setState(() => _position = 0)));
            }
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _player?.dispose();
    super.dispose();
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

    // final size = Text('16.5 MB',
    //     style: TextStyle(
    //         fontSize: 12.0,
    //         fontFamily: 'PT Root UI',
    //         color: widget.isMine
    //             ? HexColors.white.withOpacity(0.6)
    //             : HexColors.black.withOpacity(0.6)));

    final current = Text(
        _player?.duration == null
            ? ''
            : _position.toString().length > 1
                ? '00:${_position.toString()}'
                : '00:0${_position.toString()}',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final total = Text(
        _player == null
            ? ''
            : _player?.duration?.inSeconds == null
                ? ''
                : _player!.duration!.inSeconds.toString().length > 1
                    ? '00:${_player!.duration!.inSeconds.toString()}'
                    : '00:0${_player!.duration!.inSeconds.toString()}',
        style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'PT Root UI',
            color: widget.isMine ? HexColors.white : HexColors.black));

    final contentList = ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        widget.isMine
            ? Container()
            : widget.showName
                ? GestureDetector(
                    onTap: widget.onUserTap == null
                        ? null
                        : () => widget.onUserTap!(),
                    child:

                        /// USERNAME
                        Text(widget.user?.name ?? '',
                            style: TextStyle(
                                color: HexColors.grey40,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold)))
                : Container(),
        SizedBox(height: widget.showName ? 4.0 : 0.0),

        /// AUDIO
        widget.isAudio
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [current, total])
            : text,
        SizedBox(height: widget.isAudio ? 0.0 : 2.0),

        /// FILE
        widget.isFile
            // ? size
            ? Container()
            : _player != null
                ? SizedBox(
                    height: 36.0,
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                            value: _position.toDouble(),
                            max: _player!.duration?.inSeconds.toDouble() ?? 1.0,
                            // divisions: _player!.duration?.inSeconds ?? 1,
                            thumbColor: widget.isMine
                                ? HexColors.white
                                : HexColors.additionalViolet,
                            activeColor: widget.isMine
                                ? HexColors.white.withOpacity(0.75)
                                : HexColors.additionalViolet.withOpacity(0.75),
                            inactiveColor: widget.isMine
                                ? HexColors.white.withOpacity(0.3)
                                : HexColors.additionalViolet.withOpacity(0.3),
                            onChanged: (value) => {
                                  _player
                                      ?.seek(Duration(seconds: value.toInt()))
                                      .then((_) => setState(
                                          () => _position = value.toInt()))
                                })))
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
                    ? Column(children: [
                        Row(children: [
                          widget.isDownloading
                              ?
                              // Show indicator
                              Transform.scale(
                                  scale: 0.75,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 6.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        widget.isMine
                                            ? HexColors.white
                                            : HexColors.additionalViolet,
                                      )))
                              // Show file icon
                              : SvgPicture.asset('assets/ic_dialog_file.svg',
                                  color: widget.isMine
                                      ? HexColors.white
                                      : HexColors.additionalViolet,
                                  width: 40.0,
                                  height: 40.0),
                          const SizedBox(width: 10.0),
                          Expanded(child: contentList)
                        ]),
                        SizedBox(
                            height:
                                !widget.isMine && widget.isFile ? 8.0 : 0.0),
                        time
                      ])
                    : _player != null
                        ? Column(children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () => _player!.playing
                                        ? _player!.pause()
                                        : _player!.play(),
                                    child: _player == null
                                        ? Container()
                                        : SvgPicture.asset(
                                            _player!.playing
                                                ? 'assets/ic_dialog_pause.svg'
                                                : 'assets/ic_dialog_play.svg',
                                            color: widget.isMine
                                                ? HexColors.white
                                                : HexColors.additionalViolet,
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
                                widget.isMine && widget.isRead
                                    ? SvgPicture.asset('assets/ic_read.svg')
                                    : SvgPicture.asset('assets/ic_unread.svg'),
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
                  dateTime: DateTime(widget.dateTime.year,
                      widget.dateTime.month, widget.dateTime.day),
                  child: gestureDetector)
              : gestureDetector
        ]);
  }
}
