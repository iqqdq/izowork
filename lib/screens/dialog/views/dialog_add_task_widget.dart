import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/dialog/views/bubble_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';

class DialogAddTaskWidget extends StatelessWidget {
  final bool isMine;
  final bool isFile;
  final bool isAudio;
  final bool isGroupLastMessage;
  final String text;
  final DateTime dateTime;
  final VoidCallback onTap;

  const DialogAddTaskWidget(
      {Key? key,
      required this.isMine,
      required this.isFile,
      required this.isAudio,
      required this.isGroupLastMessage,
      required this.text,
      required this.dateTime,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.grey,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const DismissIndicatorWidget(),

                  /// ADDRESS
                  const TitleWidget(text: Titles.message),
                  const SizedBox(height: 16.0),
                  // Padding(
                  //     padding: EdgeInsets.only(
                  //         right: isMine ? 16.0 : 0.0,
                  //         left: isMine ? 0.0 : 16.0),
                  //     child: BubbleWidget(
                  //         showName: true,
                  //         isMine: isMine,
                  //         isFile: isFile,
                  //         isAudio: isAudio,
                  //         isGroupLastMessage: isGroupLastMessage,
                  //         animate: false,
                  //         text: text,
                  //         showDate: false,
                  //         dateTime: dateTime,
                  //         onLongPress: null)),
                  const SizedBox(height: 16.0),

                  /// BUTTON
                  ButtonWidget(title: Titles.createTask, onTap: () => onTap())
                ])));
  }
}
