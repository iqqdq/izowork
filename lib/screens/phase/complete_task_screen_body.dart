import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class CompleteTaskSheetWidget extends StatefulWidget {
  final PhaseChecklistInformation? phaseChecklistInformation;
  final Function(String, List<PlatformFile>) onTap;

  const CompleteTaskSheetWidget(
      {Key? key, this.phaseChecklistInformation, required this.onTap})
      : super(key: key);

  @override
  _CompleteTaskSheetState createState() => _CompleteTaskSheetState();
}

class _CompleteTaskSheetState extends State<CompleteTaskSheetWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<PlatformFile> _files = [];

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
                  widget.phaseChecklistInformation == null
                      ? InputWidget(
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
                        )
                      : SubtitleWidget(
                          text: widget.phaseChecklistInformation?.description ??
                              '-',
                          padding: const EdgeInsets.only(bottom: 4.0)),
                  const SizedBox(height: 16.0),

                  /// FILE LIST
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          widget.phaseChecklistInformation?.files.length ??
                              _files.length,
                      itemBuilder: (context, index) {
                        return FileListItemWidget(
                          fileName: widget.phaseChecklistInformation
                                  ?.files[index].name ??
                              _files[index].name,
                          onRemoveTap: widget.phaseChecklistInformation == null
                              ? () => _removeFile(index)
                              : null,
                        );
                      }),

                  /// ADD FILE BUTTON
                  widget.phaseChecklistInformation == null
                      ? BorderButtonWidget(
                          margin: EdgeInsets.zero,
                          title: Titles.addFile,
                          onTap: () => _addFile())
                      : Container(),

                  /// ADD BUTTON
                  ButtonWidget(
                      margin: const EdgeInsets.only(top: 16.0),
                      title: widget.phaseChecklistInformation == null
                          ? Titles.add
                          : Titles.close,
                      isDisabled: widget.phaseChecklistInformation == null
                          ? _textEditingController.text.isEmpty
                          : false,
                      onTap: () => widget.phaseChecklistInformation == null
                          ? widget.onTap(_textEditingController.text, _files)
                          : Navigator.pop(context))
                ])));
  }
}
