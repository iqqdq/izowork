import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/object_analytics_view_model.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/file_list_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

class ObjectAnalyticsScreenBodyWidget extends StatefulWidget {
  const ObjectAnalyticsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectAnalyticsScreenBodyState createState() =>
      _ObjectAnalyticsScreenBodyState();
}

class _ObjectAnalyticsScreenBodyState
    extends State<ObjectAnalyticsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late ObjectAnalyticsViewModel _objectAnalyticsViewModel;

  @override
  bool get wantKeepAlive => true;

  Widget _table(String title) {
    return ListView(
        padding: const EdgeInsets.only(bottom: 20.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          TitleWidget(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
              text: title,
              isSmall: true),
          const SizedBox(height: 10.0),

          /// TABLE
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 36.0 * 4,
              child: SpreadsheetTable(
                  cellBuilder: (_, int row, int col) => Container(
                      height: 36.0,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.65, color: HexColors.grey20)),
                      child: Center(
                          child: Text(
                              col == 0
                                  ? '${row + 1}'
                                  : col == 1
                                      ? '100 ${Titles.currency}'
                                      : 'Задачи',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: HexColors.black,
                                  fontFamily: 'PT Root UI')))),
                  legendBuilder: (_) => Container(
                      height: 36.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.65, color: HexColors.grey20)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.65, color: HexColors.grey20)),
                      child: Center(
                          child: Text('Название товара',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: HexColors.black,
                                  fontFamily: 'PT Root UI')))),
                  colHeaderBuilder: (_, index) => Container(
                      height: 36.0,
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.65, color: HexColors.grey20)),
                      child: Center(
                          child: Text(
                              index == 0
                                  ? Titles.count
                                  : index == 1
                                      ? Titles.totalPrice
                                      : Titles.complition,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: HexColors.black,
                                  fontFamily: 'PT Root UI')))),
                  rowHeaderWidth: 144.0,
                  colsHeaderHeight: 36.0,
                  cellHeight: 36.0,
                  cellWidth: 100.0,
                  rowsCount: 3,
                  colCount: 3))
        ]);
  }

  Widget _bottomTable(String title) {
    return ListView(
        padding: const EdgeInsets.only(bottom: 20.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          TitleWidget(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
              text: title,
              isSmall: true),
          const SizedBox(height: 10.0),

          /// TABLE
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 36.0 * 4,
              child: SpreadsheetTable(
                cellBuilder: (_, int row, int col) => Container(
                    height: 36.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.65, color: HexColors.grey20)),
                    child: Row(children: [
                      Text('85 %',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: HexColors.black,
                              fontFamily: 'PT Root UI'))
                    ])),
                legendBuilder: (_) => Container(
                    height: 36.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.65, color: HexColors.grey20)),
                    child: Row(children: [
                      Text(Titles.phases,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: HexColors.black,
                              fontFamily: 'PT Root UI'))
                    ])),
                rowHeaderBuilder: (_, index) => Container(
                    height: 36.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.65, color: HexColors.grey20)),
                    child: Row(children: [
                      Text('Название этапа',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: HexColors.black,
                              fontFamily: 'PT Root UI'))
                    ])),
                colHeaderBuilder: (_, index) => Container(
                    height: 36.0,
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.65, color: HexColors.grey20)),
                    child: Center(
                        child: Text(
                            index == 0 ? Titles.realization : Titles.checkLists,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: HexColors.black,
                                fontFamily: 'PT Root UI')))),
                rowHeaderWidth: 144.0,
                colsHeaderHeight: 36.0,
                cellHeight: 36.0,
                cellWidth: 110.0,
                rowsCount: 3,
                colCount: 2,
              ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _objectAnalyticsViewModel =
        Provider.of<ObjectAnalyticsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 12.0, bottom: _bottomPadding),
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
                    itemCount: 3,
                    itemBuilder: (context, index) =>
                        _table('${Titles.phase} ${index + 1}')),

                /// EFFECTIVENESS TABLE
                _bottomTable(Titles.effectiveness),

                const SizedBox(height: 20.0),

                /// TOTAL REALIZATION / EFFECTIVENESS
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    color: HexColors.secondaryMain.withOpacity(0.35),
                    child: Row(children: [
                      Expanded(
                          child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
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
                            Text('25%',
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.bold)),
                          ])),
                      Expanded(
                          child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
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
                            Text('50%',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 20.0,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.bold)),
                          ]))
                    ])),
                const SizedBox(height: 20.0),

                const TitleWidget(
                    padding:
                        EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
                    text: Titles.photo,
                    isSmall: true),
                const SizedBox(height: 10.0),

                /// PHOTO LIST
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const FileListItemWidget(fileName: 'image.png');
                    }),

                /// ADD PHOTO BUTTON
                BorderButtonWidget(
                    title: Titles.addPhoto,
                    margin: const EdgeInsets.only(
                        top: 8.0, left: 16.0, right: 16.0, bottom: 30.0),
                    onTap: () => _objectAnalyticsViewModel.pickImage()),
              ]),

          /// INDICATOR
          _objectAnalyticsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
