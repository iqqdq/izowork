import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/phase_view_model.dart';
import 'package:izowork/screens/phase/views/check_list_item_widget.dart';
import 'package:izowork/screens/phase/views/contractor_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';
import 'package:izowork/screens/phase/views/search_list_item_widget.dart';

class PhaseCreateScreenBodyWidget extends StatefulWidget {
  final Phase phase;

  const PhaseCreateScreenBodyWidget({Key? key, required this.phase})
      : super(key: key);

  @override
  _PhaseScreenBodyState createState() => _PhaseScreenBodyState();
}

class _PhaseScreenBodyState extends State<PhaseCreateScreenBodyWidget> {
  late PhaseViewModel _phaseViewModel;

  @override
  Widget build(BuildContext context) {
    _phaseViewModel = Provider.of<PhaseViewModel>(context, listen: true);

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
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(_phaseViewModel.phase.name,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'PT Root UI',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: HexColors.black))),
        body: Material(
            type: MaterialType.transparency,
            child: Container(
                color: HexColors.white,
                child: Stack(children: [
                  ListView(
                      padding: EdgeInsets.only(
                          top: 14.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 20.0 + 54.0
                              : MediaQuery.of(context).padding.bottom + 54.0),
                      children: [
                        /// PRODUCT TITLE
                        _phaseViewModel.phaseProducts.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(Titles.products,
                                    style: TextStyle(
                                        color: HexColors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold))),

                        SizedBox(
                            height: _phaseViewModel.phaseProducts.isEmpty
                                ? 0.0
                                : 16.0),

                        /// PRODUCT TABLE
                        _phaseViewModel.phaseProducts.isEmpty
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 36.0 *
                                    (_phaseViewModel.phaseProducts.length + 1),
                                child: SpreadsheetTable(
                                  cellBuilder: (_, int row, int col) =>
                                      Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.65,
                                                  color: HexColors.grey20)),
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
                                                        fontFamily:
                                                            'PT Root UI')))
                                          ])),
                                  legendBuilder: (_) => Container(
                                      height: 36.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20)),
                                      child: Row(children: [
                                        Text(Titles.product,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.ellipsis,
                                                color: HexColors.black,
                                                fontFamily: 'PT Root UI'))
                                      ])),
                                  rowHeaderBuilder: (_, index) => Container(
                                      height: 36.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20)),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(
                                                _phaseViewModel
                                                        .phaseProducts[index]
                                                        .product
                                                        ?.name ??
                                                    '-',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: HexColors.black,
                                                    fontFamily: 'PT Root UI')))
                                      ])),
                                  colHeaderBuilder: (_, index) => Container(
                                      height: 36.0,
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
                                                  fontFamily: 'PT Root UI')))),
                                  rowHeaderWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  colsHeaderHeight: 36.0,
                                  cellHeight: 36.0,
                                  cellWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                  rowsCount:
                                      _phaseViewModel.phaseProducts.length,
                                  colCount: 2,
                                )),
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
                                child: Text(Titles.contractors,
                                    style: TextStyle(
                                        color: HexColors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold))),

                        SizedBox(
                            height: _phaseViewModel.phaseContractors.isEmpty
                                ? 0.0
                                : 16.0),

                        /// CONTRACTOR LIST
                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                bottom: 10.0, left: 16.0, right: 16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _phaseViewModel.phaseContractors.length,
                            itemBuilder: (context, index) {
                              return IgnorePointer(
                                  ignoring: true,
                                  child: ContractorListItemWidget(
                                      phaseContractor: _phaseViewModel
                                          .phaseContractors[index],
                                      onTap: () => {}));
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
                                    right: 16.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _phaseViewModel.deals.length,
                                itemBuilder: (context, index) {
                                  return IgnorePointer(
                                      ignoring: true,
                                      child: SearchListItemWidget(
                                          name:
                                              '${Titles.deal} №${_phaseViewModel.deals[index].number}',
                                          onTap: () => {}));
                                }),

                        /// CHECK
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : _phaseViewModel.phaseChecklistResponse!
                                    .phaseChecklists.isEmpty
                                ? Container()
                                : const TitleWidget(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    text: Titles.checkList,
                                    isSmall: true),

                        /// CHECKBOX LIST
                        _phaseViewModel.phaseChecklistResponse == null
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, left: 16.0, right: 16.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _phaseViewModel
                                    .phaseChecklistResponse!
                                    .phaseChecklists
                                    .length,
                                itemBuilder: (context, index) {
                                  return CheckListItemWidget(
                                      isSelected: _phaseViewModel
                                          .phaseChecklistResponse!
                                          .phaseChecklists[index]
                                          .isCompleted,
                                      title: _phaseViewModel
                                          .phaseChecklistResponse!
                                          .phaseChecklists[index]
                                          .name,
                                      state: _phaseViewModel
                                          .phaseChecklistResponse!
                                          .phaseChecklists[index]
                                          .state,
                                      onTap: _phaseViewModel
                                                  .phaseChecklistResponse!
                                                  .canEdit ==
                                              true
                                          ? () => _phaseViewModel
                                              .showCompleteTaskSheet(
                                                  context, index)
                                          : null);
                                }),

                        /// SET TASK BUTTON
                        _phaseViewModel.loadingStatus == LoadingStatus.searching
                            ? Container()
                            : BorderButtonWidget(
                                title: Titles.setTask,
                                margin: const EdgeInsets.only(
                                    bottom: 20.0, left: 16.0, right: 16.0),
                                onTap: () => _phaseViewModel
                                    .showTaskCreateScreen(context)),

                        /// OPEN DEAL BUTTON
                        _phaseViewModel.loadingStatus == LoadingStatus.searching
                            ? Container()
                            : BorderButtonWidget(
                                title: Titles.openDeal,
                                margin: const EdgeInsets.only(
                                    bottom: 16.0, left: 16.0, right: 16.0),
                                onTap: () => _phaseViewModel
                                    .showDealCreateScreen(context)),
                      ]),

                  /// EDIT PHASE BUTTON
                  _phaseViewModel.loadingStatus == LoadingStatus.searching
                      ? Container()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: ButtonWidget(
                              isDisabled: false,
                              title: Titles.edit,
                              margin: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom ==
                                          0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                              onTap: () => _phaseViewModel
                                  .showPhaseCreateScreen(context))),
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
