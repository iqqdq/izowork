import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/phase_checklist/view_model/phase_checklist_view_model.dart';

import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/phase_checklist_messages/view/phase_checklist_messages_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PhaseChecklistBodyWidget extends StatefulWidget {
  final VoidCallback onInfoCreate;

  const PhaseChecklistBodyWidget({
    Key? key,
    required this.onInfoCreate,
  }) : super(key: key);

  @override
  _PhaseChecklistBodyState createState() => _PhaseChecklistBodyState();
}

class _PhaseChecklistBodyState extends State<PhaseChecklistBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late PhaseChecklistViewModel _phaseChecklistViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_phaseChecklistViewModel.phaseChecklistInfo == null) {
        _focusNode.requestFocus();
      }
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
    _phaseChecklistViewModel = Provider.of<PhaseChecklistViewModel>(
      context,
      listen: true,
    );

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: HexColors.white,
          child: Column(children: [
            const SizedBox(height: 24.0),

            /// DISMISS INDICATOR
            // const DismissIndicatorWidget(),
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// TITLE
                    Expanded(
                        child: TitleWidget(
                      text:
                          '${Titles.taskCompleteInfo}\n"${_phaseChecklistViewModel.phaseChecklist.name}"',
                      padding: const EdgeInsets.only(right: 12.0),
                    )),

                    /// CLOSE BUTTON
                    BackButtonWidget(
                      asset: 'assets/ic_close.svg',
                      onTap: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ]),
            Expanded(
              child: _phaseChecklistViewModel.loadingStatus ==
                      LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? MediaQuery.of(context).viewInsets.bottom + 20.0
                            : MediaQuery.of(context).viewInsets.bottom +
                                MediaQuery.of(context).padding.bottom,
                      ),
                      children: [
                          /// REASON INPUT
                          _phaseChecklistViewModel.phaseChecklistInfo == null
                              ? InputWidget(
                                  textEditingController: _textEditingController,
                                  focusNode: _focusNode,
                                  height: 200.0,
                                  maxLines: 10,
                                  margin: EdgeInsets.zero,
                                  placeholder: '${Titles.description}...',
                                  onTap: () => setState,
                                  onChange: (text) => setState(() {}),
                                )
                              : SubtitleWidget(
                                  text: _phaseChecklistViewModel
                                          .phaseChecklistInfo?.description ??
                                      '-',
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                ),

                          /// FILE LIST
                          ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _phaseChecklistViewModel
                                      .phaseChecklistInfo?.files.length ??
                                  _phaseChecklistViewModel.files.length,
                              itemBuilder: (context, index) {
                                return FileListItemWidget(
                                  key: ValueKey(
                                    _phaseChecklistViewModel.phaseChecklistInfo
                                            ?.files[index].name ??
                                        _phaseChecklistViewModel
                                            .files[index].name,
                                  ),
                                  fileName: _phaseChecklistViewModel
                                          .phaseChecklistInfo
                                          ?.files[index]
                                          .name ??
                                      _phaseChecklistViewModel
                                          .files[index].name,
                                  onTap: () =>
                                      _phaseChecklistViewModel.openFile(index),
                                  onRemoveTap: _phaseChecklistViewModel
                                              .phaseChecklistInfo ==
                                          null
                                      ? () => _phaseChecklistViewModel
                                          .removeFile(index)
                                      : null,
                                );
                              }),

                          /// ADD FILE BUTTON
                          _phaseChecklistViewModel.phaseChecklistInfo == null
                              ? BorderButtonWidget(
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  title: Titles.addFile,
                                  onTap: () =>
                                      _phaseChecklistViewModel.addFile(),
                                )
                              : Container(),

                          /// ADD BUTTON
                          _phaseChecklistViewModel.phaseChecklistInfo == null
                              ? ButtonWidget(
                                  margin: EdgeInsets.zero,
                                  isDisabled:
                                      _textEditingController.text.isEmpty,
                                  title: Titles.send,
                                  onTap: () => _createInfo(),
                                )
                              : Container(),
                        ]),
            ),

            /// COMMENTS BUTTON
            _phaseChecklistViewModel.phaseChecklistInfo != null
                ? BorderButtonWidget(
                    margin: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : 0.0,
                    ),
                    title: Titles.comments,
                    onTap: () => _showPhaseChecklistCommentsScreenWidget(
                        phaseChecklist:
                            _phaseChecklistViewModel.phaseChecklist),
                  )
                : Container(),
          ]),
        ),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showPhaseChecklistCommentsScreenWidget(
          {required PhaseChecklist phaseChecklist}) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) =>
            PhaseChecklistCommentsScreenWidget(phaseChecklist: phaseChecklist),
      );

  // MARK: -
  // MARK: - FUNCTIONS

  void _createInfo() async {
    await _phaseChecklistViewModel
        .createPhaseChecklistInfo(_textEditingController.text);

    if (_phaseChecklistViewModel.phaseChecklistInfo != null) {
      widget.onInfoCreate();
      Navigator.pop(context);
    }
  }
}
