import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/models/deal_view_model.dart';
import 'package:izowork/screens/deal/views/process_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
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
        '';

    List<DealProduct> _products = _dealViewModel.deal?.dealProducts ??
        _dealViewModel.selectedDeal.dealProducts;

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
                      shrinkWrap: true,
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
                            text: '???'),

                        /// OBJECT
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.object,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: '???'),

                        /// PHASE
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.phase,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: _dealViewModel.dealStage?.name ?? '???'),

                        /// COMPANY
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.company,
                            isSmall: true),
                        SubtitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: '???'),

                        /// COMMENT
                        const TitleWidget(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 4.0),
                            text: Titles.comment,
                            isSmall: true),
                        SubtitleWidget(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            text: _comment),

                        /// PRODUCT TABLE
                        _products.isEmpty
                            ? Container()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 36.0 * (_products.length + 1),
                                child: SpreadsheetTable(
                                  cellBuilder: (_, int row, int col) =>
                                      Container(
                                          height: 36.0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.65,
                                                  color: HexColors.grey20)),
                                          child: Center(
                                              child: Text(
                                                  col == 0
                                                      ? _products[row]
                                                              .product
                                                              ?.unit ??
                                                          '-'
                                                      : col == 1
                                                          ? _products[row]
                                                              .count
                                                              .toString()
                                                          : _products[row]
                                                                  .product
                                                                  ?.price
                                                                  .toString() ??
                                                              '0',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: HexColors.black,
                                                      fontFamily:
                                                          'PT Root UI')))),
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
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
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
                                        Text(
                                            _products[index].product?.name ??
                                                '-',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: HexColors.black,
                                                fontFamily: 'PT Root UI'))
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
                                                  ? Titles.unit
                                                  : index == 1
                                                      ? Titles.count
                                                      : '${Titles.price}, ${Titles.currency}',
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
                                  rowsCount: _products.length,
                                  colCount: 3,
                                )),

                        /// FILE LIST
                        _dealViewModel.deal == null ||
                                _dealViewModel.deal!.files.isEmpty ||
                                _dealViewModel.selectedDeal.files.isEmpty
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 16.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _dealViewModel.deal?.files.length ??
                                    _dealViewModel.selectedDeal.files.length,
                                itemBuilder: (context, index) {
                                  return FileListItemWidget(
                                      fileName: _dealViewModel
                                              .deal?.files[index].name ??
                                          _dealViewModel
                                              .selectedDeal.files[index].name,
                                      isDownloading:
                                          _dealViewModel.downloadIndex == index,
                                      onTap: () => _dealViewModel.openFile(
                                          context, index));
                                }),

                        /// PROCESS LIST
                        // const TitleWidget(
                        //     padding: EdgeInsets.only(
                        //         top: 16.0,
                        //         left: 16.0,
                        //         right: 16.0,
                        //         bottom: 10.0),
                        //     text: Titles.processes,
                        //     isSmall: true),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 16.0),
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemCount: 2,
                        //     itemBuilder: (context, index) {
                        //       return ProcessListItemWidget(
                        //         isExpanded:
                        //             _dealViewModel.expanded.contains(index),
                        //         isReady: index == 0,
                        //         onExpandTap: () => _dealViewModel.expand(index),
                        //         onMenuTap: (index) => _dealViewModel
                        //             .showProcessActionScreenSheet(context),
                        //         onAddProcessTap: () => _dealViewModel
                        //             .showSelectionScreenSheet(context),
                        //       );
                        //     }),

                        /// CLOSE DEAL BUTTON
                        BorderButtonWidget(
                            title: Titles.closeDeal,
                            margin: const EdgeInsets.only(
                                left: 16.0,
                                top: 6.0,
                                right: 16.0,
                                bottom: 16.0),
                            onTap: () => _dealViewModel
                                .showCloseDealScreenSheet(context)),
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
                          onTap: () => _dealViewModel
                              .showDealCreateScreenSheet(context)))
                ]))));
  }
}
