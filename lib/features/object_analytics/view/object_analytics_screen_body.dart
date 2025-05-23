import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/object_analytics/view_model/object_analytics_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

class ObjectAnalyticsScreenBodyWidget extends StatefulWidget {
  const ObjectAnalyticsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectAnalyticsScreenBodyState createState() =>
      _ObjectAnalyticsScreenBodyState();
}

class _ObjectAnalyticsScreenBodyState
    extends State<ObjectAnalyticsScreenBodyWidget> {
  late ObjectAnalyticsViewModel _objectAnalyticsViewModel;

  @override
  Widget build(BuildContext context) {
    _objectAnalyticsViewModel = Provider.of<ObjectAnalyticsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: BackButtonWidget(onTap: () => Navigator.pop(context))),
          title: Text(Titles.analytics,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'PT Root UI',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: HexColors.black))),
      body: SizedBox.expand(
        child: Stack(children: [
          /// INDICATOR
          _objectAnalyticsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: 12.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom,
                  ),
                  children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(Titles.buildingPhases,
                              style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 18.0,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.bold))),

                      /// PRODUCT TABLE LIST VIEW
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 20.0),
                        shrinkWrap: true,
                        itemCount: _objectAnalyticsViewModel.phases.length,
                        itemBuilder: (context, index) => _table(index),
                      ),

                      /// EFFECTIVENESS TABLE
                      _bottomTable(Titles.effectiveness),

                      /// TOTAL REALIZATION / EFFECTIVENESS
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          color:
                              HexColors.secondaryMain.withValues(alpha: 0.35),
                          child: Row(children: [
                            Expanded(
                                child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                  Text(Titles.totalEealization,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 14.0,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'PT Root UI')),
                                  const SizedBox(height: 10.0),

                                  /// REALIZATION
                                  Text(
                                      '${_objectAnalyticsViewModel.object.readiness}%',
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 20.0,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'PT Root UI',
                                          fontWeight: FontWeight.bold)),
                                ])),
                            Expanded(
                                child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                  Text(Titles.totalEffectiveness,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 14.0,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'PT Root UI')),
                                  const SizedBox(height: 10.0),

                                  /// EFFECTIVENESS
                                  Text(
                                      '${_objectAnalyticsViewModel.object.efficiency}%',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: HexColors.black,
                                          fontSize: 20.0,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'PT Root UI',
                                          fontWeight: FontWeight.bold)),
                                ]))
                          ])),

                      _objectAnalyticsViewModel.object.files.isEmpty
                          ? Container()
                          : const TitleWidget(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 14.0),
                              text: Titles.files,
                              isSmall: true,
                            ),

                      /// PHOTO LIST
                      ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              _objectAnalyticsViewModel.object.files.length,
                          itemBuilder: (context, index) {
                            final file =
                                _objectAnalyticsViewModel.object.files[index];

                            return FileListItemWidget(
                              key: ValueKey(file.id),
                              fileName: file.name,
                              onTap: () =>
                                  _objectAnalyticsViewModel.openFile(index),
                            );
                          })
                    ]),
          const SeparatorWidget()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Widget _table(int index) {
    List<PhaseProduct> phaseProducts =
        _objectAnalyticsViewModel.phaseProductList.isEmpty
            ? []
            : _objectAnalyticsViewModel.phaseProductList[index];

    return phaseProducts.isEmpty
        ? Container()
        : ListView(
            padding: const EdgeInsets.only(bottom: 20.0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
                TitleWidget(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 4.0,
                  ),
                  text: _objectAnalyticsViewModel.phases[index].name,
                  isSmall: true,
                ),
                const SizedBox(height: 10.0),

                /// TABLE
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0 * (phaseProducts.length + 1),
                    child: SpreadsheetTable(
                      cellBuilder: (_, int row, int col) => Container(
                          height: 42.0,
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 0.65,
                            color: HexColors.grey20,
                          )),
                          child: Row(children: [
                            Expanded(
                                child: Text(
                                    col == 0
                                        ? phaseProducts[row].count.toString()
                                        : col == 1
                                            ? '${(phaseProducts[row].product?.price ?? 0).toString()} ${Titles.currency}'
                                            : col == 2
                                                ? (phaseProducts[row].count -
                                                        phaseProducts[row]
                                                            .bought)
                                                    .toString()
                                                : col == 3
                                                    ? phaseProducts[row]
                                                                .bought ==
                                                            0
                                                        ? '0 %'
                                                        : ((phaseProducts[row]
                                                                            .bought /
                                                                        phaseProducts[row]
                                                                            .count) *
                                                                    100)
                                                                .toString() +
                                                            ' %'
                                                    : (phaseProducts[row]
                                                                .count -
                                                            (phaseProducts[row]
                                                                    .count -
                                                                phaseProducts[
                                                                        row]
                                                                    .bought))
                                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: HexColors.black,
                                    )))
                          ])),
                      legendBuilder: (_) => Container(
                          height: 42.0,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 0.65,
                            color: HexColors.grey20,
                          )),
                          child: Row(children: [
                            Text(Titles.product,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: HexColors.black,
                                    fontFamily: 'PT Root UI'))
                          ])),
                      rowHeaderBuilder: (_, index) => Container(
                        height: 42.0,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 0.65,
                          color: HexColors.grey20,
                        )),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                                  phaseProducts[index].product?.name ?? '-',
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: HexColors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'PT Root UI',
                                  )))
                        ]),
                      ),
                      colHeaderBuilder: (_, index) => Container(
                          height: 42.0,
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 0.65,
                            color: HexColors.grey20,
                          )),
                          child: Center(
                              child: Text(
                                  index == 0
                                      ? Titles.count
                                      : index == 1
                                          ? Titles.totalPrice
                                          : index == 2
                                              ? Titles.remain
                                              : index == 3
                                                  ? Titles.complitionPercent
                                                  : Titles.complitionSum,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: HexColors.black,
                                    fontFamily: 'PT Root UI',
                                  )))),
                      rowHeaderWidth: 144.0,
                      colsHeaderHeight: 42.0,
                      cellHeight: 50.0,
                      cellWidth: 100.0,
                      rowsCount: phaseProducts.length,
                      colCount: 5,
                    ))
              ]);
  }

  Widget _bottomTable(String title) => ListView(
          padding: const EdgeInsets.only(bottom: 20.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            TitleWidget(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 4.0,
                ),
                text: title,
                isSmall: true),
            const SizedBox(height: 10.0),

            /// TABLE
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0 * (_objectAnalyticsViewModel.phases.length + 1),
                child: SpreadsheetTable(
                  cellBuilder: (_, int row, int col) => Container(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 0.65,
                        color: HexColors.grey20,
                      )),
                      child: Row(children: [
                        Expanded(
                            child: Text(
                                '${col == 0 ? _objectAnalyticsViewModel.phases[row].readiness.toString() : _objectAnalyticsViewModel.phases[row].efficiency.toString()} %',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: HexColors.black,
                                    fontFamily: 'PT Root UI')))
                      ])),
                  legendBuilder: (_) => Container(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 0.65,
                        color: HexColors.grey20,
                      )),
                      child: Row(children: [
                        Text(Titles.phases,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: HexColors.black,
                                fontFamily: 'PT Root UI'))
                      ])),
                  rowHeaderBuilder: (_, index) => Container(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 0.65,
                        color: HexColors.grey20,
                      )),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            _objectAnalyticsViewModel.phases[index].name,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: HexColors.black,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: 'PT Root UI'),
                          ),
                        )
                      ])),
                  colHeaderBuilder: (_, index) => Container(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 0.65,
                        color: HexColors.grey20,
                      )),
                      child: Row(children: [
                        Expanded(
                            child: Text(
                                index == 0
                                    ? Titles.realization
                                    : Titles.checkLists,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: HexColors.black,
                                  fontFamily: 'PT Root UI',
                                )))
                      ])),
                  rowHeaderWidth: 144.0,
                  colsHeaderHeight: 42.0,
                  cellHeight: 50.0,
                  cellWidth: 110.0,
                  rowsCount: _objectAnalyticsViewModel.phases.length,
                  colCount: 2,
                ))
          ]);
}
