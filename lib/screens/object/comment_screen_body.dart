import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/title_widget.dart';

class CommentScreenBodyWidget extends StatefulWidget {
  final Function(String) onTap;

  const CommentScreenBodyWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  _CommentScreenBodyState createState() => _CommentScreenBodyState();
}

class _CommentScreenBodyState extends State<CommentScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 20.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const SizedBox(height: 6.0),
                  const DismissIndicatorWidget(),

                  /// TITLE
                  const TitleWidget(
                      text: Titles.addComment, padding: EdgeInsets.zero),
                  const SizedBox(height: 16.0),

                  /// REASON INPUT
                  InputWidget(
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                    height: 168.0,
                    maxLines: 10,
                    margin: EdgeInsets.zero,
                    placeholder: '${Titles.comment}...',
                    onTap: () => setState,
                    onChange: (text) => {
                      // TODO DESCRTIPTION
                    },
                  ),

                  /// ADD BUTTON
                  ButtonWidget(
                      margin: const EdgeInsets.only(top: 16.0),
                      title: Titles.send,
                      isDisabled: _textEditingController.text.isEmpty,
                      onTap: () => widget.onTap(_textEditingController.text))
                ])));
  }
}
