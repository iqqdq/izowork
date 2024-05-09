import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/phase_checklist_create/phase_checklist_create_screen.dart';
import 'package:izowork/screens/phase/views/check_list_item_widget.dart';
import 'package:izowork/screens/phase/views/contractor_list_item_widget.dart';
import 'package:izowork/screens/phase_checklist_messages/phase_checklist_messages_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';
import 'package:izowork/screens/phase/views/search_list_item_widget.dart';

class PhaseCreateScreenBodyWidget extends StatefulWidget {
  final User? user;
  final Phase phase;

  const PhaseCreateScreenBodyWidget({
    Key? key,
    required this.user,
    required this.phase,
  }) : super(key: key);

  @override
  _PhaseScreenBodyState createState() => _PhaseScreenBodyState();
}

class _PhaseScreenBodyState extends State<PhaseCreateScreenBodyWidget> {
  late PhaseViewModel _phaseViewModel;

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

  void _showPhaseChecklistCreateScreen() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => PhaseChecklistCreateScreenWidget(
            phaseId: widget.phase.id,
            onPop: (phaseChecklist) => {
              if (phaseChecklist != null)
                Future.delayed(
                  const Duration(milliseconds: 500),
                  () => setState(() => _phaseViewModel
                      .phaseChecklistResponse?.phaseChecklists
                      .add(phaseChecklist)),
                )
            },
          ));

  void _showAcceptDeclinePhaseChecklistAlert({
    required PhaseChecklist phaseChecklist,
    required Widget statusWidget,
  }) =>
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        phaseChecklist.name,
                        maxLines: 8,
                        style: TextStyle(
                          color: HexColors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )),
                    const SizedBox(width: 12.0),
                    statusWidget,
                  ],
                ),
                actions: <Widget>[
                  Row(children: [
                    Expanded(
                        child: BorderButtonWidget(
                            margin: EdgeInsets.zero,
                            title: Titles.accept,
                            onTap: () {
                              // TODO: - ACCEPT CHECKLIST
                            })),
                    const SizedBox(width: 16.0),
                    Expanded(
                        child: BorderButtonWidget(
                            margin: EdgeInsets.zero,
                            title: Titles.decline,
                            isDestructive: true,
                            onTap: () {
                              // TODO: - DECLINE CHECKLIST
                            })),
                  ]),
                ]);
          });

  void _showRemovePhaseChecklistAlert(
          {required PhaseChecklist phaseChecklist}) =>
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                  '${Titles.deleteAreYouSure} "${phaseChecklist.name}"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HexColors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: <Widget>[
                  Row(children: [
                    Expanded(
                      child: BorderButtonWidget(
                          margin: EdgeInsets.zero,
                          title: Titles.delete,
                          isDestructive: true,
                          onTap: () => _phaseViewModel
                              .removePhaseChecklist(phaseChecklist.id)
                              .then((value) => {
                                    Navigator.pop(context),

                                    /// SHOW DELETE CHECKLIST ERROR
                                    if (mounted &&
                                        _phaseViewModel.error != null)
                                      Toast().showTopToast(
                                          this.context, _phaseViewModel.error!),
                                  })),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: BorderButtonWidget(
                        margin: EdgeInsets.zero,
                        title: Titles.cancel,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ]),
                ]);
          });

  // MARK: -
  // MARK: - BUILD

  @override
  Widget build(BuildContext context) {
    _phaseViewModel = Provider.of<PhaseViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BackButtonWidget(onTap: () => Navigator.pop(context)),
          ),
          title: Text(
            _phaseViewModel.phase.name,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: 'PT Root UI',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColors.black,
            ),
          ),
        ),
        body: Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColors.white,
                child: Stack(children: [
                  ListView(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0 + 54.0
                            : MediaQuery.of(context).padding.bottom + 54.0,
                      ),
                      children: [
                        /// PRODUCT TITLE
                        _phaseViewModel.phaseProducts.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  Titles.products,
                                  style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 18.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                        SizedBox(
                            height: _phaseViewModel.phaseProducts.isEmpty
                                ? 0.0
                                : 16.0),

                        /// PRODUCT TABLE
                        _phaseViewModel.phaseProducts.isEmpty
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0 *
                                    (_phaseViewModel.phaseProducts.length + 1),
                                child: SpreadsheetTable(
                                  cellBuilder: (_, int row, int col) =>
                                      Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20,
                                            ),
                                          ),
                                          child: Row(children: [
                                            Expanded(
                                              child: Text(
                                                col == 0
                                                    ? _phaseViewModel
                                                        .phaseProducts[row]
                                                        .termInDays
                                                        .toString()
                                                    : _phaseViewModel
                                                        .phaseProducts[row]
                                                        .count
                                                        .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: HexColors.black,
                                                  fontFamily: 'PT Root UI',
                                                ),
                                              ),
                                            )
                                          ])),
                                  legendBuilder: (_) => Container(
                                    height: 42.0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.65,
                                        color: HexColors.grey20,
                                      ),
                                    ),
                                    child: Row(children: [
                                      Text(
                                        Titles.product,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                          color: HexColors.black,
                                          fontFamily: 'PT Root UI',
                                        ),
                                      ),
                                    ]),
                                  ),
                                  rowHeaderBuilder: (_, index) => Container(
                                      height: 42.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.65,
                                          color: HexColors.grey20,
                                        ),
                                      ),
                                      child: Row(children: [
                                        Expanded(
                                          child: Text(
                                            _phaseViewModel.phaseProducts[index]
                                                    .product?.name ??
                                                '-',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: HexColors.black,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'PT Root UI'),
                                          ),
                                        )
                                      ])),
                                  colHeaderBuilder: (_, index) => Container(
                                    height: 42.0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.65,
                                            color: HexColors.grey20)),
                                    child: Center(
                                      child: Text(
                                        index == 0
                                            ? Titles.deliveryTime
                                            : Titles.count,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: HexColors.black,
                                          fontFamily: 'PT Root UI',
                                        ),
                                      ),
                                    ),
                                  ),
                                  rowHeaderWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  colsHeaderHeight: 42.0,
                                  cellHeight: 50.0,
                                  cellWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                  rowsCount:
                                      _phaseViewModel.phaseProducts.length,
                                  colCount: 2,
                                ),
                              ),
                        SizedBox(
                            height: _phaseViewModel.phaseProducts.isEmpty
                                ? 0.0
                                : 20.0),

                        /// CONTRACTOR TITLE
                        _phaseViewModel.phaseContractors.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  Titles.contractors,
                                  style: TextStyle(
                                      color: HexColors.black,
                                      fontSize: 18.0,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                        SizedBox(
                            height: _phaseViewModel.phaseContractors.isEmpty
                                ? 0.0
                                : 16.0),

                        /// CONTRACTOR LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _phaseViewModel.phaseContractors.length,
                            itemBuilder: (context, index) {
                              return IgnorePointer(
                                  key: ValueKey(_phaseViewModel
                                      .phaseContractors[index].id),
                                  ignoring: true,
                                  child: ContractorListItemWidget(
                                    phaseContractor:
                                        _phaseViewModel.phaseContractors[index],
                                    onTap: () => {},
                                  ));
                            }),

                        /// DEALS
                        _phaseViewModel.deals.isEmpty
                            ? Container()
                            : const TitleWidget(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                text: Titles.deals,
                                isSmall: true),

                        /// DEAL LIST
                        _phaseViewModel.deals.isEmpty
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                  top: 12.0,
                                  bottom: 10.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _phaseViewModel.deals.length,
                                itemBuilder: (context, index) {
                                  return SearchListItemWidget(
                                    key: ValueKey(_phaseViewModel.deals[index]),
                                    name:
                                        '${Titles.deal} №${_phaseViewModel.deals[index].number}',
                                    onTap: () =>
                                        _phaseViewModel.showDealScreenWidget(
                                      context,
                                      index,
                                    ),
                                  );
                                }),

                        /// OPEN DEAL BUTTON
                        // _phaseViewModel.phaseChecklistResponse == null
                        //     ? Container()
                        //     : _phaseViewModel.phaseChecklistResponse!
                        //             .phaseChecklists.isEmpty
                        //         ? Container()
                        //         : BorderButtonWidget(
                        //             title: Titles.openDeal,
                        //             margin: const EdgeInsets.only(
                        //               bottom: 30.0,
                        //               left: 16.0,
                        //               right: 16.0,
                        //             ),
                        //             onTap: () => _phaseViewModel
                        //                 .showDealCreateScreen(context),
                        //           ),

                        /// SET TASK BUTTON
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : _phaseViewModel.phaseChecklistResponse!
                                    .phaseChecklists.isEmpty
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.setTask,
                                    margin: const EdgeInsets.only(
                                        bottom: 20.0, left: 16.0, right: 16.0),
                                    onTap: () => _phaseViewModel
                                        .showTaskCreateScreen(context),
                                  ),

                        /// CHECKLIST TITLE
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : _phaseViewModel.phaseChecklistResponse!
                                    .phaseChecklists.isEmpty
                                ? Container()
                                : const TitleWidget(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    text: Titles.checkList,
                                    isSmall: true,
                                  ),

                        /// CHECKBOX LIST
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                  bottom: 20.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _phaseViewModel
                                    .phaseChecklistResponse!
                                    .phaseChecklists
                                    .length,
                                itemBuilder: (context, index) {
                                  var phaseChecklist = _phaseViewModel
                                      .phaseChecklistResponse!
                                      .phaseChecklists[index];

                                  return CheckListItemWidget(
                                    key: ValueKey(phaseChecklist.id),
                                    isSelected: phaseChecklist.isCompleted,
                                    title: phaseChecklist.name,
                                    state: phaseChecklist.state,
                                    onTap: () => phaseChecklist.state ==
                                            PhaseChecklistState.created
                                        ? _phaseViewModel.showCompleteTaskSheet(
                                            this.context,
                                            index,
                                          )
                                        : _showPhaseChecklistCommentsScreenWidget(
                                            phaseChecklist: phaseChecklist),
                                    onStatusTap: (statusWidget) =>
                                        _showAcceptDeclinePhaseChecklistAlert(
                                      statusWidget: statusWidget,
                                      phaseChecklist: phaseChecklist,
                                    ),
                                    onRemoveTap: widget.user?.state != 'ADMIN'
                                        ? null
                                        : () => _showRemovePhaseChecklistAlert(
                                            phaseChecklist: phaseChecklist),
                                  );
                                }),

                        /// CREATE CHECKLIST BUTTON
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : _phaseViewModel.phaseChecklistResponse!
                                    .phaseChecklists.isEmpty
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.createChecklist,
                                    margin: const EdgeInsets.only(
                                      bottom: 20.0,
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    onTap: () =>
                                        _showPhaseChecklistCreateScreen(),
                                  ),
                      ]),

                  /// EDIT PHASE BUTTON
                  _phaseViewModel.phaseChecklistResponse == null
                      ? Container()
                      : _phaseViewModel
                              .phaseChecklistResponse!.phaseChecklists.isEmpty
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: ButtonWidget(
                                  title: Titles.edit,
                                  margin: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom ==
                                              0.0
                                          ? 20.0
                                          : MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                  onTap: () =>
                                      _phaseViewModel.showPhaseCreateScreen(
                                          context,
                                          () =>
                                              // UPDATE UI
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) =>
                                                      setState(() {}))))),
                  const SeparatorWidget(),

                  /// INDICATOR
                  Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: _phaseViewModel.loadingStatus ==
                              LoadingStatus.searching
                          ? const LoadingIndicatorWidget()
                          : const SizedBox(height: 60.0))
                ]))));
  }
}
