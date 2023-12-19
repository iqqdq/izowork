import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/complete_checklist_view_model.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class CompleteChecklistBodyWidget extends StatefulWidget {
  final String title;
  final Function(String, List<PlatformFile>) onTap;

  const CompleteChecklistBodyWidget(
      {Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  _CompleteChecklistBodyState createState() => _CompleteChecklistBodyState();
}

class _CompleteChecklistBodyState extends State<CompleteChecklistBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late CompleteChecklistViewModel _completeChecklistViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_completeChecklistViewModel.phaseChecklistInformation == null) {
        _focusNode.requestFocus();
      }
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
    _completeChecklistViewModel = Provider.of<CompleteChecklistViewModel>(
      context,
      listen: true,
    );

    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  if (_scrollController.position.pixels == 0.0) {
                    Navigator.pop(context);
                  }

                  // Return true to cancel the notification bubbling. Return false (or null) to
                  // allow the notification to continue to be dispatched to further ancestors.
                  return true;
                },
                child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 8.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? MediaQuery.of(context).viewInsets.bottom + 20.0
                            : MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.of(context).padding.bottom),
                    children: [
                      /// DISMISS INDICATOR
                      const SizedBox(height: 6.0),
                      const DismissIndicatorWidget(),

                      /// TITLE
                      TitleWidget(
                          text: '${Titles.taskCompleteInfo}\n"${widget.title}"',
                          padding: EdgeInsets.zero),
                      const SizedBox(height: 24.0),

                      /// REASON INPUT
                      _completeChecklistViewModel.phaseChecklistInformation ==
                              null
                          ? InputWidget(
                              textEditingController: _textEditingController,
                              focusNode: _focusNode,
                              height: 168.0,
                              maxLines: 10,
                              margin: EdgeInsets.zero,
                              placeholder: '${Titles.description}...',
                              onTap: () => setState,
                              onChange: (text) => setState(() {}),
                            )
                          : SubtitleWidget(
                              text: _completeChecklistViewModel
                                      .phaseChecklistInformation?.description ??
                                  '-',
                              padding: const EdgeInsets.only(bottom: 4.0)),

                      /// FILE LIST
                      ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _completeChecklistViewModel
                                  .phaseChecklistInformation?.files.length ??
                              _completeChecklistViewModel.files.length,
                          itemBuilder: (context, index) {
                            return FileListItemWidget(
                              fileName: _completeChecklistViewModel
                                      .phaseChecklistInformation
                                      ?.files[index]
                                      .name ??
                                  _completeChecklistViewModel.files[index].name,
                              onTap: () => _completeChecklistViewModel.openFile(
                                  context, index),
                              onRemoveTap: _completeChecklistViewModel
                                          .phaseChecklistInformation ==
                                      null
                                  ? () => _completeChecklistViewModel
                                      .removeFile(index)
                                  : null,
                            );
                          }),

                      /// ADD FILE BUTTON
                      _completeChecklistViewModel.phaseChecklistInformation ==
                              null
                          ? BorderButtonWidget(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              title: Titles.addFile,
                              onTap: () =>
                                  _completeChecklistViewModel.addFile())
                          : Container(),

                      /// ADD BUTTON
                      ButtonWidget(
                          margin: EdgeInsets.zero,
                          title: _completeChecklistViewModel
                                      .phaseChecklistInformation ==
                                  null
                              ? Titles.add
                              : Titles.close,
                          isDisabled: _completeChecklistViewModel
                                      .phaseChecklistInformation !=
                                  null
                              ? false
                              : _textEditingController.text.isEmpty,
                          onTap: () => _completeChecklistViewModel
                                      .phaseChecklistInformation ==
                                  null
                              ? widget.onTap(_textEditingController.text,
                                  _completeChecklistViewModel.files)
                              : Navigator.pop(context)),
                    ]))));
  }
}
