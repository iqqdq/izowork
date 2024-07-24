// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/deal/view_model/deal_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/deal/view/sheets/deal_close_sheet.dart';
import 'package:izowork/features/deal/view/sheets/deal_process_action_sheet.dart';
import 'package:izowork/features/deal/view/views/deal_process_list_item_widget.dart';
import 'package:izowork/features/deal_create/view/deal_create_screen.dart';
import 'package:izowork/features/deal_process/view/deal_process_screen.dart';
import 'package:izowork/features/selection/view/selection_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
    _dealViewModel = Provider.of<DealViewModel>(
      context,
      listen: true,
    );

    final startDateTime = _dealViewModel.deal == null
        ? null
        : _dealViewModel.deal?.createdAt ?? _dealViewModel.deal!.createdAt;

    final endDateTime = _dealViewModel.deal == null
        ? null
        : _dealViewModel.deal?.finishAt ?? _dealViewModel.deal!.finishAt;

    final comment =
        _dealViewModel.deal?.comment ?? _dealViewModel.deal?.comment ?? '-';

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BackButtonWidget(onTap: () => Navigator.pop(context))),
        title: Text(
          _dealViewModel.deal == null
              ? ''
              : '${Titles.deal} ' + (_dealViewModel.deal!.number).toString(),
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontFamily: 'PT Root UI',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: HexColors.black,
          ),
        ),
      ),
      body: _dealViewModel.deal == null
          ? const LoadingIndicatorWidget()
          : Material(
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
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: startDateTime == null
                              ? ''
                              : DateTimeFormatter().formatDateTimeToString(
                                  dateTime: startDateTime,
                                  showTime: false,
                                  showMonthName: false,
                                ),
                        ),

                        /// END DATE
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.endDate,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: endDateTime == null
                              ? ''
                              : DateTimeFormatter().formatDateTimeToString(
                                  dateTime: endDateTime,
                                  showTime: false,
                                  showMonthName: false,
                                ),
                        ),

                        /// RESPONSIBLE
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.responsible,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: _dealViewModel.deal?.responsible?.name ?? '-',
                        ),

                        /// OBJECT
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.object,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: _dealViewModel.deal?.object?.name ?? '-',
                        ),

                        /// PHASE
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.phase,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: _dealViewModel.phase?.name ?? '-',
                        ),

                        /// COMPANY
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.company,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                          ),
                          text: _dealViewModel.deal?.company?.name ?? '-',
                        ),

                        /// COMMENT
                        const TitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 4.0,
                          ),
                          text: Titles.comment,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: _dealViewModel.dealProducts.isEmpty
                                ? 0.0
                                : 16.0,
                          ),
                          text: comment,
                        ),

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
                                        color: HexColors.grey20,
                                      ),
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: Text(
                                          col == 0
                                              ? _dealViewModel.dealProducts[row]
                                                      .product?.unit ??
                                                  '-'
                                              : col == 1
                                                  ? _dealViewModel
                                                      .dealProducts[row].count
                                                      .toString()
                                                  : _dealViewModel
                                                          .dealProducts[row]
                                                          .product
                                                          ?.price
                                                          .toString() ??
                                                      '-',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: HexColors.black,
                                            fontFamily: 'PT Root UI',
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                  legendBuilder: (_) => Container(
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
                                            Titles.product,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: HexColors.black,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: 'PT Root UI',
                                            ),
                                          ),
                                        )
                                      ])),
                                  rowHeaderBuilder: (_, index) => Container(
                                    height: 42.0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.65,
                                        color: HexColors.grey20,
                                      ),
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: Text(
                                          _dealViewModel.dealProducts[index]
                                                  .product?.name ??
                                              '-',
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: HexColors.black,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'PT Root UI',
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
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
                                          color: HexColors.black,
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
                                  rowsCount: _dealViewModel.dealProducts.length,
                                  colCount: 3,
                                ),
                              ),

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
                                      bottom: 10.0,
                                    ),
                                  ),

                        /// FILE LIST
                        _dealViewModel.deal == null
                            ? const SizedBox(height: 16.0)
                            : _dealViewModel.deal!.files.isEmpty
                                ? const SizedBox(height: 16.0)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                      bottom: 10.0,
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        _dealViewModel.deal?.files.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final file =
                                          _dealViewModel.deal?.files[index];

                                      return _dealViewModel.deal == null
                                          ? Container()
                                          : FileListItemWidget(
                                              key: ValueKey(file?.id),
                                              fileName: file?.name ?? '',
                                              isDownloading: _dealViewModel
                                                      .downloadIndex ==
                                                  index,
                                              onTap: () => _dealViewModel
                                                  .openFile(index),
                                            );
                                    }),

                        /// PROCESS LIST
                        _dealViewModel.dealStages.isEmpty
                            ? const SizedBox(height: 16.0)
                            : const TitleWidget(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 10.0,
                                ),
                                text: Titles.processes,
                                isSmall: true,
                              ),
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
                                      key: ValueKey(
                                          _dealViewModel.dealStages[index]),
                                      dealStage:
                                          _dealViewModel.dealStages[index],
                                      dealProcesses: _dealViewModel
                                              .dealStages[index].processes ??
                                          [],
                                      isExpanded: _dealViewModel.expanded
                                          .contains(index),
                                      onTap: () => _dealViewModel.expand(index),
                                      onMenuTap: (dealProcess) =>
                                          _showDealProcessActionSheet(
                                              dealProcess),
                                      onProcessTap: (dealProcess) =>
                                          _showDealProcessScreen(dealProcess),
                                      onAddProcessTap: containsHidden
                                          ? () =>
                                              _showDealProcessSelectionSheet(
                                                  index)
                                          : null,
                                    );
                            }),

                        /// CLOSE DEAL BUTTON
                        _dealViewModel.deal == null
                            ? Container()
                            : _dealViewModel.deal!.closed
                                ? Container()
                                : BorderButtonWidget(
                                    title: Titles.closeDeal,
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                      top: 6.0,
                                      right: 16.0,
                                      bottom: 16.0,
                                    ),
                                    onTap: () => _showDealCloseSheet(),
                                  ),
                      ]),

                  /// EDIT DEAL BUTTON
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonWidget(
                      title: Titles.edit,
                      margin: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom,
                      ),
                      onTap: () => _showDealCreateSheet(),
                    ),
                  ),
                  const SeparatorWidget(),

                  /// INDICATOR
                  _dealViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container()
                ]),
              ),
            ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showDealCreateSheet() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DealCreateScreenWidget(
              deal: _dealViewModel.deal,
              phase: _dealViewModel.phase,
              onCreate: (
                deal,
                dealProducts,
              ) =>
                  _dealViewModel.updateDeal(
                    deal,
                    dealProducts,
                  )),
        ),
      );

  void _showDealCloseSheet() {
    if (_dealViewModel.deal == null) return;
    List<File> files = [];

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => DealCloseSheetWidget(
          onTap: (
        text,
        platformFiles,
      ) =>
              {
                Navigator.pop(context),

                /// Update files
                for (var element in platformFiles)
                  if (element.path != null) files.add(File(element.path!)),

                /// Close deal
                _dealViewModel.closeDeal(text).then((value) async => {
                      files.isNotEmpty
                          ? await _dealViewModel.uploadFiles(
                              _dealViewModel.deal!.id,
                              files,
                            )
                          : Toast().showTopToast(
                              '${Titles.deal} ${_dealViewModel.deal!.number} успешно закрыта')
                    }),
              }),
    );
  }

  void _showDealProcessScreen(DealProcess dealProcess) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DealProcessScreenWidget(dealProcess: dealProcess)));

  void _showDealProcessSelectionSheet(int index) {
    List<String> items = [];

    if (_dealViewModel.dealStages[index].processes!.isNotEmpty) {
      _dealViewModel.dealStages[index].processes?.forEach((element) {
        if (element.hidden) {
          items.add(element.name);
        }
      });

      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SelectionScreenWidget(
            title: Titles.addProcess,
            value: '',
            items: items,
            onSelectTap: (value) => {
                  _dealViewModel.dealStages[index].processes
                      ?.forEach((element) {
                    if (element.name == value) {
                      _dealViewModel.updateDealProcess(
                        false,
                        element.id,
                        element.status,
                      );
                    }
                  })
                }),
      );
    }
  }

  void _showDealProcessActionSheet(DealProcess process) =>
      showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DealProcessActionSheet(
            title: process.name,
            onTap: (index) => {
                  if (index == 0)
                    _dealViewModel.updateDealProcess(
                      true,
                      process.id,
                      process.status,
                    )
                }),
      );
}
