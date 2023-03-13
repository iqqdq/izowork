import 'dart:math';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/analytics_companies_view_model.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/analytics/views/horizontal_chart/horizontal_chart_widget.dart';
import 'package:izowork/screens/analytics/views/analitics_manager_list_item_widget.dart';
import 'package:izowork/screens/analytics/views/pie_chart/pie_chart_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class AnalyticsCompaniesScreenBodyWidget extends StatefulWidget {
  const AnalyticsCompaniesScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnalyticsCompaniesScreenBodyState createState() =>
      _AnalyticsCompaniesScreenBodyState();
}

class _AnalyticsCompaniesScreenBodyState
    extends State<AnalyticsCompaniesScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late AnalyticsCompaniesViewModel _analyticsCompaniesViewModel;

  @override
  bool get wantKeepAlive => true;

  Widget _title(String text) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(text,
            style: TextStyle(
                color: HexColors.black,
                fontSize: 19.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w500)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _analyticsCompaniesViewModel =
        Provider.of<AnalyticsCompaniesViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 12.0, bottom: _bottomPadding),
              children: [
                _title(Titles.pledgetProductValue),

                /// PRODUCT SELECTION, TON'S
                SelectionInputWidget(
                    title: Titles.product,
                    value: Titles.tonProductPlaceholder,
                    isVertical: true,
                    onTap: () => _analyticsCompaniesViewModel.showSearchSheet(
                        context, SearchType.product)),

                /// PRODUCT HORIZONTAL CHART
                HorizontalChartWidget(onMaxScrollExtent: () => {}),
                const SizedBox(height: 24.0),

                _title(Titles.realizedProductValue),

                /// PRODUCT SELECTION, LITERS
                SelectionInputWidget(
                    title: Titles.product,
                    value: Titles.literProductPlaceholder,
                    isVertical: true,
                    onTap: () => _analyticsCompaniesViewModel.showSearchSheet(
                        context, SearchType.product)),
                HorizontalChartWidget(onMaxScrollExtent: () => {}),
                const SizedBox(height: 24.0),

                /// COMPANY PIE CHART
                _title(Titles.companyTotal),
                PieChartWidget(items: [
                  PieChartModel(
                      Titles.generalContractor, HexColors.primaryMain, 25),
                  PieChartModel(Titles.designer, HexColors.grey20, 15),
                  PieChartModel(Titles.customer, HexColors.additionalViolet, 60)
                ]),
                const SizedBox(height: 24.0),

                /// OBJECT PIE CHART
                _title(Titles.objectTotal),

                PieChartWidget(items: [
                  PieChartModel(
                      Titles.administrationBuilding, HexColors.primaryMain, 5),
                  PieChartModel(
                      Titles.appartmentComplex, HexColors.turquoiseColor, 10),
                  PieChartModel(Titles.schools, HexColors.blueColor, 25),
                  PieChartModel(Titles.hospitals, HexColors.pinkColor, 8),
                  PieChartModel(
                      Titles.industrialObject, HexColors.darkBlueColor, 13),
                  PieChartModel(
                      Titles.logicalCenters, HexColors.lightPinkColor, 17),
                  PieChartModel(
                      Titles.reconstructableObjects, HexColors.grey20, 22)
                ]),
                const SizedBox(height: 24.0),

                /// OBJECT TOTAL COUNT
                _title(Titles.dealTotal),

                /// FILIAL SELECTION
                SelectionInputWidget(
                    title: Titles.filial,
                    value: Titles.notSelected,
                    isVertical: true,
                    onTap: () => _analyticsCompaniesViewModel.showSearchSheet(
                        context, SearchType.filial)),
                const SizedBox(height: 26.0),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    child: Text('1 350 340',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HexColors.additionalViolet,
                            fontSize: 32.0,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold))),
                Text(Titles.dealTotalCount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: HexColors.grey50,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI')),
                const SizedBox(height: 40.0),

                /// MANAGER TOTAL LIST
                _title(Titles.managerTotal),

                /// FILIAL SELECTION
                SelectionInputWidget(
                    title: Titles.filial,
                    value: Titles.notSelected,
                    isVertical: true,
                    onTap: () => _analyticsCompaniesViewModel.showSearchSheet(
                        context, SearchType.filial)),
                const SizedBox(height: 20.0),

                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return AnalitycsManagerListItemWidget(
                        value: Random().nextInt(99).toDouble(),
                        onTap: () => {},
                      );
                    })
              ]),

          /// INDICATOR
          _analyticsCompaniesViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
