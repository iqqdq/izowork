import 'dart:io';

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/extensions/extensions.dart';
import 'package:izowork/features/phase_checklist_create/view_model/phase_checklist_create_view_model.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  static const TextStyle _textStyle = TextStyle(
    overflow: TextOverflow.ellipsis,
    fontFamily: 'PT Root UI',
  );

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late PhaseChecklistCreateViewModel _checklistCreateViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          const Duration(milliseconds: 500), () => _focusNode.requestFocus());
    });
  }

  @override
  void dispose() {
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
        padding: EdgeInsets.only(
            top: 24.0,
            bottom: MediaQuery.of(context).padding.bottom == 0.0
                ? 12.0
                : MediaQuery.of(context).padding.bottom),
        color: HexColors.white,
        child: Column(children: [
          /// TITLE
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitleWidget(text: Titles.newCheckList),
                BackButtonWidget(
                  asset: 'assets/ic_close.svg',
                  onTap: () => {
                    _focusNode.unfocus(),
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => Navigator.pop(context),
                    )
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 24.0),
          Expanded(
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
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
                  /// CHECKLIST NAME INPUT
                  InputWidget(
                      textEditingController: _textEditingController,
                      focusNode: _focusNode,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      height: 120.0,
                      placeholder: Titles.checkListName,
                      onTap: () => setState(() {}),
                      onChange: (text) => setState(() {}),
                      onEditingComplete: () => setState(() {})),

                  /// DEADLINE BUTTON

                  BorderButtonWidget(
                    margin: EdgeInsets.zero,
                    title: _checklistCreateViewModel.pickedDateTime == null
                        ? '${Titles.add} ${Titles.deadline}'
                        : '${Titles.deadline}: ${_checklistCreateViewModel.pickedDateTime!.toShortDate()}',
                    onTap: () => _showDateTimeSelectionSheet(),
                  ),
                ]),
          ),

          /// CREATE BUTTON
          _checklistCreateViewModel.loadingStatus == LoadingStatus.searching
              ? Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  height: 54.0,
                  child: const LoadingIndicatorWidget(onlyIndicator: true),
                )
              : ButtonWidget(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  title: Titles.add,
                  isDisabled: _textEditingController.text.isEmpty,
                  onTap: () => {
                        FocusScope.of(context).unfocus(),
                        _createChecklist(),
                      }),
        ]),
      ),
    );
  }

  // MARK: - FUNCTION'S

  void _createChecklist() => _checklistCreateViewModel
      .createPhaseChecklist(name: _textEditingController.text)
      .then((value) => {
            if (_checklistCreateViewModel.loadingStatus ==
                LoadingStatus.completed)
              Navigator.pop(context)
            else
              Toast().showTopToast(_checklistCreateViewModel.error ??
                  'Возникла ошибка при добавлении чеклиста')
          });

  void _showDateTimeSelectionSheet() {
    DateTime? newDateTime;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _checklistCreateViewModel.minDateTime,
            maxDateTime: _checklistCreateViewModel.maxDateTime,
            initialDateTime:
                _checklistCreateViewModel.pickedDateTime ?? DateTime.now(),
            showDays: true,
            locale: Platform.localeName,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: _textStyle.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            ),
            selecteTextStyle: _textStyle.copyWith(
              fontSize: 14.0,
              color: HexColors.black,
              fontWeight: FontWeight.w400,
            ),
            unselectedTextStyle: _textStyle.copyWith(
              fontSize: 12.0,
              color: HexColors.grey70,
              fontWeight: FontWeight.w400,
            ),
            onTap: (dateTime) => {
                  newDateTime = dateTime,
                  Navigator.pop(context),
                })).whenComplete(() {
      _checklistCreateViewModel.changePickedDateTime(newDateTime);
    });
  }
}
