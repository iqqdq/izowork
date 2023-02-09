import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class CompleteTaskSheetWidget extends StatefulWidget {
  final bool isComplete;
  final Function(String, List<PlatformFile>) onTap;

  const CompleteTaskSheetWidget(
      {Key? key, required this.isComplete, required this.onTap})
      : super(key: key);

  @override
  _CompleteTaskSheetState createState() => _CompleteTaskSheetState();
}

class _CompleteTaskSheetState extends State<CompleteTaskSheetWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<PlatformFile> _files = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      for (var file in result.files) {
        _files.add(file);
      }
    }
  }

  void _removeFile(int index) {
    setState(() => _files.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 20.0
                        : MediaQuery.of(context).padding.bottom),
                shrinkWrap: true,
                children: [
                  /// DISMISS INDICATOR
                  const SizedBox(height: 6.0),
                  const DismissIndicatorWidget(),

                  /// TITLE
                  const TitleWidget(
                      text: Titles.taskCompleteInfo, padding: EdgeInsets.zero),
                  const SizedBox(height: 16.0),

                  /// REASON INPUT
                  widget.isComplete
                      ? const SubtitleWidget(
                          text:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          padding: EdgeInsets.only(bottom: 4.0))
                      : InputWidget(
                          textEditingController: _textEditingController,
                          focusNode: _focusNode,
                          height: 168.0,
                          maxLines: 10,
                          margin: EdgeInsets.zero,
                          placeholder: '${Titles.description}...',
                          onTap: () => setState,
                          onChange: (text) => {
                            // TODO DESCRTIPTION
                          },
                        ),
                  const SizedBox(height: 16.0),

                  /// FILE LIST
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.isComplete ? 2 : _files.length,
                      itemBuilder: (context, index) {
                        return FileListItemWidget(
                          fileName: widget.isComplete
                              ? 'file.png'
                              : _files[index].name,
                          onRemoveTap: widget.isComplete
                              ? null
                              : () => _removeFile(index),
                        );
                      }),

                  /// ADD FILE BUTTON
                  widget.isComplete
                      ? Container()
                      : BorderButtonWidget(
                          margin: EdgeInsets.zero,
                          title: Titles.addFile,
                          onTap: () => _addFile()),

                  /// ADD BUTTON
                  ButtonWidget(
                      margin: const EdgeInsets.only(top: 16.0),
                      title: widget.isComplete ? Titles.close : Titles.add,
                      isDisabled: widget.isComplete
                          ? false
                          : _textEditingController.text.isEmpty,
                      onTap: () => widget.isComplete
                          ? Navigator.pop(context)
                          : widget.onTap(_textEditingController.text, _files))
                ])));
  }
}
