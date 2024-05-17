import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCompleteBodyWidget extends StatefulWidget {
  final String title;
  final Function(String, List<PlatformFile>) onTap;

  const PhaseChecklistCompleteBodyWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _PhaseChecklistCompleteBodyState createState() =>
      _PhaseChecklistCompleteBodyState();
}

class _PhaseChecklistCompleteBodyState
    extends State<PhaseChecklistCompleteBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late PhaseChecklistCompleteViewModel _phaseChecklistCompleteViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_phaseChecklistCompleteViewModel.phaseChecklistInfo == null) {
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
    _phaseChecklistCompleteViewModel =
        Provider.of<PhaseChecklistCompleteViewModel>(
      context,
      listen: true,
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: HexColors.white,
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
              _phaseChecklistCompleteViewModel.phaseChecklistInfo == null
                  ? IgnorePointer(
                      child: InputWidget(
                      textEditingController: _textEditingController,
                      focusNode: _focusNode,
                      height: 168.0,
                      maxLines: 10,
                      margin: EdgeInsets.zero,
                      placeholder: '${Titles.description}...',
                      onTap: () => setState,
                      onChange: (text) => setState(() {}),
                    ))
                  : SubtitleWidget(
                      text: _phaseChecklistCompleteViewModel
                              .phaseChecklistInfo?.description ??
                          '-',
                      padding: const EdgeInsets.only(bottom: 4.0),
                    ),

              /// FILE LIST
              ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _phaseChecklistCompleteViewModel
                          .phaseChecklistInfo?.files.length ??
                      _phaseChecklistCompleteViewModel.files.length,
                  itemBuilder: (context, index) {
                    return FileListItemWidget(
                      key: ValueKey(
                        _phaseChecklistCompleteViewModel
                                .phaseChecklistInfo?.files[index].name ??
                            _phaseChecklistCompleteViewModel.files[index].name,
                      ),
                      fileName: _phaseChecklistCompleteViewModel
                              .phaseChecklistInfo?.files[index].name ??
                          _phaseChecklistCompleteViewModel.files[index].name,
                      onTap: () => _phaseChecklistCompleteViewModel.openFile(
                          context, index),
                      onRemoveTap: _phaseChecklistCompleteViewModel
                                  .phaseChecklistInfo ==
                              null
                          ? () =>
                              _phaseChecklistCompleteViewModel.removeFile(index)
                          : null,
                    );
                  }),

              /// ADD FILE BUTTON
              _phaseChecklistCompleteViewModel.phaseChecklistInfo != null
                  ? BorderButtonWidget(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      title: Titles.addFile,
                      onTap: () => _phaseChecklistCompleteViewModel.addFile(),
                    )
                  : Container(),

              /// ADD BUTTON
              ButtonWidget(
                margin: EdgeInsets.zero,
                title:
                    _phaseChecklistCompleteViewModel.phaseChecklistInfo != null
                        ? Titles.add
                        : Titles.close,
                onTap: () =>
                    _phaseChecklistCompleteViewModel.phaseChecklistInfo == null
                        ? widget.onTap(
                            _textEditingController.text,
                            _phaseChecklistCompleteViewModel.files,
                          )
                        : Navigator.pop(context),
              ),
            ]),
      ),
    );
  }
}
