import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/entities/response/news_comment.dart';
import 'package:izowork/api/urls.dart';

class CommentBubbleWidget extends StatefulWidget {
  final NewsComment comment;
  final bool animate;
  final VoidCallback onUserTap;

  const CommentBubbleWidget(
      {Key? key,
      required this.comment,
      required this.animate,
      required this.onUserTap})
      : super(key: key);

  @override
  _CommentBubbleState createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<CommentBubbleWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _day = widget.comment.createdAt.day.toString().characters.length == 1
        ? '0${widget.comment.createdAt.day}'
        : '${widget.comment.createdAt.day}';
    final _month =
        widget.comment.createdAt.month.toString().characters.length == 1
            ? '0${widget.comment.createdAt.month}'
            : '${widget.comment.createdAt.month}';
    final _year = '${widget.comment.createdAt.year}';

    return SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
        axisAlignment: -1,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: HexColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 0.5, color: HexColors.grey30)),
            child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Row(children: [
                              /// AVATAR
                              Stack(children: [
                                SvgPicture.asset('assets/ic_avatar.svg',
                                    color: HexColors.grey40,
                                    width: 24.0,
                                    height: 24.0,
                                    fit: BoxFit.cover),
                                widget.comment.user.avatar == null
                                    ? Container()
                                    : widget.comment.user.avatar!.isEmpty
                                        ? Container()
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: CachedNetworkImage(
                                                cacheKey:
                                                    widget.comment.user.avatar,
                                                imageUrl: avatarUrl +
                                                    widget.comment.user.avatar!,
                                                width: 24.0,
                                                height: 24.0,
                                                memCacheWidth: 24 *
                                                    MediaQuery.of(context)
                                                        .devicePixelRatio
                                                        .round(),
                                                fit: BoxFit.cover)),
                              ]),
                              const SizedBox(width: 10.0),

                              ///   NAME
                              Text(widget.comment.user.name,
                                  style: TextStyle(
                                      color: HexColors.grey50,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold)),
                            ]),
                            onTap: () => widget.onUserTap()),
                        const SizedBox(height: 12.0),

                        /// COMMENT
                        Text(widget.comment.comment,
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI')),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /// DATE
                              Text('$_day.$_month.$_year',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: HexColors.grey40,
                                      fontSize: 12.0,
                                      fontFamily: 'PT Root UI'))
                            ])
                      ])
                ])));
  }
}
