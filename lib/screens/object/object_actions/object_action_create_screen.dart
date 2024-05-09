import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class ObjectActionCreateSheetWidget extends StatefulWidget {
  final Function(String) onTap;

  const ObjectActionCreateSheetWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  _ObjectActionCreateSheetState createState() =>
      _ObjectActionCreateSheetState();
}

class _ObjectActionCreateSheetState
    extends State<ObjectActionCreateSheetWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
            child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  if (_scrollController.position.pixels == 0.0 &&
                      MediaQuery.of(context).viewInsets.bottom == 0.0) {
                    Navigator.pop(context);
                  }

                  // Return true to cancel the notification bubbling. Return false (or null) to
                  // allow the notification to continue to be dispatched to further ancestors.
                  return true;
                },
                child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 8.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: (MediaQuery.of(context).padding.bottom ==
                                        0.0
                                    ? 20.0
                                    : MediaQuery.of(context).padding.bottom) +
                                MediaQuery.of(context).viewInsets.bottom),
                        children: [
                          /// DISMISS INDICATOR
                          const SizedBox(height: 6.0),
                          const DismissIndicatorWidget(),

                          /// TITLE
                          const TitleWidget(
                              text: Titles.addAction, padding: EdgeInsets.zero),
                          const SizedBox(height: 16.0),

                          /// REASON INPUT
                          InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            height: 168.0,
                            maxLines: 10,
                            margin: EdgeInsets.zero,
                            placeholder: '${Titles.action}...',
                            onTap: () => setState(() {}),
                            onChange: (text) => setState(() {}),
                          ),

                          /// ADD BUTTON
                          ButtonWidget(
                              margin: const EdgeInsets.only(top: 16.0),
                              title: Titles.add,
                              isDisabled: _textEditingController.text.isEmpty,
                              onTap: () =>
                                  widget.onTap(_textEditingController.text))
                        ])))));
  }
}
