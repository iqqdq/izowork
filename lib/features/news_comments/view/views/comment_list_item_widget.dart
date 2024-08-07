import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

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
              border: Border.all(
                width: 0.5,
                color: HexColors.grey30,
              ),
            ),
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

                              AvatarWidget(
                                url: avatarUrl,
                                endpoint: widget.comment.user.avatar,
                                size: 24.0,
                              ),

                              const SizedBox(width: 10.0),

                              ///   NAME
                              Text(
                                widget.comment.user.name,
                                style: TextStyle(
                                  color: HexColors.grey50,
                                  fontSize: 14.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            onTap: () => widget.onUserTap()),
                        const SizedBox(height: 12.0),

                        /// COMMENT
                        Text(
                          widget.comment.comment,
                          style: TextStyle(
                            color: HexColors.black,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI',
                          ),
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              /// DATE
                              Text(
                                DateTimeFormatter().formatDateTimeToString(
                                  dateTime: widget.comment.createdAt,
                                  showTime: true,
                                  showMonthName: true,
                                ),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: HexColors.grey40,
                                  fontSize: 12.0,
                                  fontFamily: 'PT Root UI',
                                ),
                              )
                            ])
                      ])
                ])));
  }
}
