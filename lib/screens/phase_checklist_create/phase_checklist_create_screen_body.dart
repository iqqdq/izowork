import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class PhaseChecklistCreateBodyWidget extends StatefulWidget {
  final String phaseId;
  final Function(PhaseChecklist? phaseChecklist) onPop;

  const PhaseChecklistCreateBodyWidget({
    Key? key,
    required this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  _PhaseChecklistCreateBodyState createState() =>
      _PhaseChecklistCreateBodyState();
}

class _PhaseChecklistCreateBodyState
    extends State<PhaseChecklistCreateBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late PhaseChecklistCreateViewModel _checklistCreateViewModel;

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

    widget.onPop(_checklistCreateViewModel.phaseChecklist);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checklistCreateViewModel = Provider.of<PhaseChecklistCreateViewModel>(
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
                const TitleWidget(
                  text: Titles.newCheckList,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24.0),

                /// CHECKLIST NAME INPUT
                InputWidget(
                    textEditingController: _textEditingController,
                    focusNode: _focusNode,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    height: 56.0,
                    placeholder: Titles.checkListName,
                    onTap: () => setState(() {}),
                    onChange: (text) => setState(() {}),
                    onEditingComplete: () => setState(() {})),

                /// CREATE BUTTON
                _checklistCreateViewModel.loadingStatus ==
                        LoadingStatus.searching
                    ? const SizedBox(
                        height: 54.0,
                        child: LoadingIndicatorWidget(onlyIndicator: true),
                      )
                    : ButtonWidget(
                        margin: const EdgeInsets.only(top: 20.0),
                        title: Titles.add,
                        isDisabled: _textEditingController.text.isEmpty,
                        onTap: () => {
                              FocusScope.of(context).unfocus(),
                              _checklistCreateViewModel
                                  .createPhaseChecklist(
                                      name: _textEditingController.text)
                                  .then((value) => {
                                        if (_checklistCreateViewModel
                                                .loadingStatus ==
                                            LoadingStatus.completed)
                                          Navigator.pop(context)
                                        else
                                          Toast().showTopToast(
                                            context,
                                            _checklistCreateViewModel.error ??
                                                'Возникла ошибка при добавлении чеклиста',
                                          )
                                      }),
                            }),
              ]),
        ),
      ),
    );
  }
}
