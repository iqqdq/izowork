// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/deal_view_model.dart';
import 'package:izowork/screens/deal/views/deal_process_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

class DealScreenBodyWidget extends StatefulWidget {
  const DealScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DealScreenBodyState createState() => _DealScreenBodyState();
}

class _DealScreenBodyState extends State<DealScreenBodyWidget> {
  late DealViewModel _dealViewModel;

  @override
  Widget build(BuildContext context) {
    _dealViewModel = Provider.of<DealViewModel>(context, listen: true);

    final startDateTime = DateTime.parse(_dealViewModel.deal?.createdAt ??
        _dealViewModel.selectedDeal.createdAt);

    final _startDay = startDateTime.day.toString().length == 1
        ? '0${startDateTime.day}'
        : '${startDateTime.day}';
    final _startMonth = startDateTime.month.toString().length == 1
        ? '0${startDateTime.month}'
        : '${startDateTime.month}';
    final _startYear = '${startDateTime.year}';

    final endDateTime = DateTime.parse(
        _dealViewModel.deal?.finishAt ?? _dealViewModel.selectedDeal.finishAt);

    final _endDay = endDateTime.day.toString().length == 1
        ? '0${endDateTime.day}'
        : '${endDateTime.day}';
    final _endMonth = endDateTime.month.toString().length == 1
        ? '0${endDateTime.month}'
        : '${endDateTime.month}';
    final _endYear = '${endDateTime.year}';

    final _comment = _dealViewModel.deal?.comment ??
        _dealViewModel.selectedDeal.comment ??
        '-';

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BackButtonWidget(onTap: () => Navigator.pop(context))),
            title: Text(
                Titles.deal +
                    ' ' +
                    (_dealViewModel.deal?.number ??
                            _dealViewModel.selectedDeal.number)
                        .toString(),
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
                        /// START DATE
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.startDate,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: '$_startDay.$_startMonth.$_startYear'),

                        /// END DATE
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.endDate,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: '$_endDay.$_endMonth.$_endYear'),

                        /// RESPONSIBLE
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.responsible,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text:
                                _dealViewModel.deal?.responsible?.name ?? '-'),

                        /// OBJECT
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.object,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: _dealViewModel.deal?.object?.name ?? '-'),

                        /// PHASE
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.phase,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: _dealViewModel.phase?.name ?? '-'),

                        /// COMPANY
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.company,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: _dealViewModel.deal?.company?.name ?? '-'),

                        /// COMMENT
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.comment,
                            isSmall: true),
                        SubtitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: _dealViewModel.dealProducts.isEmpty
                                    ? 0.0
                                    : 16.0),
                            text: _comment.isEmpty ? '-' : _comment),

                        /// PRODUCT TABLE
                        _dealViewModel.dealProducts.isEmpty
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0 *
                                    (_dealViewModel.dealProducts.length + 1),
                                child: SpreadsheetTable(
                                  cellBuilder: (_, int row, int col) =>
                                      Container(
                                          height: 42.0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.65,
                                                  color: HexColors.grey20)),
                                          child: Row(children: [
                                            Expanded(
                                                child: Text(
                                                    col == 0
                                                        ? _dealViewModel
                                                                .dealProducts[
                                                                    row]
                                                                .product
                                                                ?.unit ??
                                                            '-'
                                                        : col == 1
                                                            ? _dealViewModel
                                                                .dealProducts[
                                                                    row]
                                                                .count
                                                                .toString()
                                                            : _dealViewModel
                                                                    .dealProducts[
                                                                        row]
                                                                    .product
                                                                    ?.price
                                                                    .toString() ??
                                                                '-',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: HexColors.black,
                                                        fontFamily:
                                                            'PT Root UI')))
                                          ])),
                                  legendBuilder: (_) => Container(
                                      height: 42.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20)),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(Titles.product,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontFamily: 'PT Root UI')))
                                      ])),
                                  rowHeaderBuilder: (_, index) => Container(
                                      height: 42.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20)),
                                      child: Row(children: [
                                        Expanded(
                                            child: Text(
                                                _dealViewModel
                                                        .dealProducts[index]
                                                        .product
                                                        ?.name ??
                                                    '-',
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: HexColors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontFamily: 'PT Root UI')))
                                      ])),
                                  colHeaderBuilder: (_, index) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.65,
                                              color: HexColors.grey20)),
                                      child: Center(
                                          child: Text(
                                              index == 0
                                                  ? Titles.unit
                                                  : index == 1
                                                      ? Titles.count
                                                      : '${Titles.price}, ${Titles.currency}',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: HexColors.black)))),
                                  rowHeaderWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  colsHeaderHeight: 42.0,
                                  cellHeight: 50.0,
                                  cellWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                  rowsCount: _dealViewModel.dealProducts.length,
                                  colCount: 3,
                                )),

                        _dealViewModel.deal == null
                            ? Container()
                            : _dealViewModel.deal!.files.isEmpty
                                ? Container()
                                : const TitleWidget(
                                    text: Titles.files,
                                    isSmall: true,
                                    padding: EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        top: 16.0,
                                        bottom: 10.0)),

                        /// FILE LIST
                        _dealViewModel.deal == null
                            ? const SizedBox(height: 16.0)
                            : _dealViewModel.deal!.files.isEmpty
                                ? const SizedBox(height: 16.0)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, left: 16.0, right: 16.0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        _dealViewModel.deal?.files.length ??
                                            _dealViewModel
                                                .selectedDeal.files.length,
                                    itemBuilder: (context, index) {
                                      return FileListItemWidget(
                                          fileName: _dealViewModel
                                                  .deal?.files[index].name ??
                                              _dealViewModel.selectedDeal
                                                  .files[index].name,
                                          isDownloading:
                                              _dealViewModel.downloadIndex ==
                                                  index,
                                          onTap: () => _dealViewModel.openFile(
                                              context, index));
                                    }),

                        /// PROCESS LIST
                        _dealViewModel.dealStages.isEmpty
                            ? const SizedBox(height: 16.0)
                            : const TitleWidget(
                                padding: EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 10.0),
                                text: Titles.processes,
                                isSmall: true),
                        ListView.builder(
                            shrinkWrap: true,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _dealViewModel.dealStages.length,
                            itemBuilder: (context, index) {
                              bool containsHidden = false;
                              _dealViewModel.dealStages[index].processes
                                  ?.forEach((element) {
                                if (element.hidden) {
                                  containsHidden = true;
                                  return;
                                }
                              });

                              return _dealViewModel
                                          .dealStages[index].processes ==
                                      null
                                  ? Container()
                                  : DealProcessListItemWidget(
                                      dealStage:
                                          _dealViewModel.dealStages[index],
                                      dealProcesses: _dealViewModel
                                              .dealStages[index].processes ??
                                          [],
                                      isExpanded: _dealViewModel.expanded
                                          .contains(index),
                                      onTap: () => _dealViewModel.expand(index),
                                      onMenuTap: (dealProcess) => _dealViewModel
                                          .showDealProcessActionSheet(
                                        context,
                                        dealProcess,
                                      ),
                                      onProcessTap: (dealProcess) =>
                                          _dealViewModel.showDealProcessScreen(
                                        context,
                                        dealProcess,
                                      ),
                                      onAddProcessTap: containsHidden
                                          ? () => _dealViewModel
                                                  .showDealProcessSelectionSheet(
                                                context,
                                                index,
                                              )
                                          : null,
                                    );
                            }),

                        /// CLOSE DEAL BUTTON
                        _dealViewModel.deal?.closed ??
                                _dealViewModel.selectedDeal.closed
                            ? Container()
                            : BorderButtonWidget(
                                title: Titles.closeDeal,
                                margin: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 6.0,
                                    right: 16.0,
                                    bottom: 16.0),
                                onTap: () =>
                                    _dealViewModel.showDealCloseSheet(context)),
                      ]),

                  /// EDIT DEAL BUTTON
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                          title: Titles.edit,
                          margin: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom:
                                  MediaQuery.of(context).padding.bottom == 0.0
                                      ? 20.0
                                      : MediaQuery.of(context).padding.bottom),
                          onTap: () =>
                              _dealViewModel.showDealCreateSheet(context))),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _dealViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]))));
  }
}
