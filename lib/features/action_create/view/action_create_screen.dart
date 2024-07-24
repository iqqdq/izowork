import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class TextViewSheetWidget extends StatefulWidget {
  final String title;
  final String label;
  final Function(String) onTap;

  const TextViewSheetWidget({
    Key? key,
    required this.title,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  _TextViewSheetState createState() => _TextViewSheetState();
}

class _TextViewSheetState extends State<TextViewSheetWidget> {
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
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 16.0,
          right: 16.0,
          bottom: (MediaQuery.of(context).padding.bottom == 0.0
                  ? 20.0
                  : MediaQuery.of(context).padding.bottom) +
              MediaQuery.of(context).viewInsets.bottom,
        ),
        color: HexColors.white,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(children: [
            /// DISMISS INDICATOR
            const SizedBox(height: 6.0),
            const DismissIndicatorWidget(),

            /// TITLE / CLOSE BUTTON
            Row(
              children: [
                Expanded(
                  child: TitleWidget(
                    text: widget.title,
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 12.0),
                BackButtonWidget(
                  asset: 'assets/ic_close.svg',
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 16.0),

            /// REASON INPUT
            InputWidget(
              textEditingController: _textEditingController,
              focusNode: _focusNode,
              height: 168.0,
              maxLines: 10,
              margin: EdgeInsets.zero,
              placeholder: widget.label,
              onTap: () => setState(() {}),
              onChange: (text) => setState(
                () {},
              ),
            ),
            const Spacer(),

            /// ADD BUTTON
            ButtonWidget(
              margin: const EdgeInsets.only(top: 16.0),
              title: Titles.add,
              isDisabled: _textEditingController.text.isEmpty,
              onTap: () => widget.onTap(_textEditingController.text),
            )
          ]),
        ),
      ),
    );
  }
}
