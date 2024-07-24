// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/analytics/view_model/analytics_companies_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/analytics/view/views/horizontal_chart/horizontal_chart_widget.dart';
import 'package:izowork/features/analytics/view/views/analitics_manager_list_item_widget.dart';
import 'package:izowork/features/analytics/view/views/pie_chart/pie_chart_widget.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/features/search_office/view/search_office_screen.dart';
import 'package:izowork/features/search_product/view/search_product_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
              fontWeight: FontWeight.w500,
            )));
  }

  Widget _companyPieChart() {
    List<PieChartModel> items = [];

    if (_analyticsCompaniesViewModel.companyAnalytics != null) {
      if (_analyticsCompaniesViewModel.companyAnalytics!.labels.isNotEmpty &&
          _analyticsCompaniesViewModel.companyAnalytics!.labels.length ==
              _analyticsCompaniesViewModel.companyAnalytics!.data.length) {
        int index = 0;

        _analyticsCompaniesViewModel.companyAnalytics?.labels
            .forEach((element) {
          items.add(PieChartModel(
              element,
              HexColor(generateRandomHexColor()),
              _analyticsCompaniesViewModel.companyAnalytics!.data[index]
                  .toDouble()));
          index++;
        });
      }
    }

    return items.isEmpty ? Container() : PieChartWidget(items: items);
  }

  Widget _objectPieChart() {
    List<PieChartModel> items = [];

    if (_analyticsCompaniesViewModel.objectAnalytics != null) {
      if (_analyticsCompaniesViewModel.objectAnalytics!.labels.isNotEmpty &&
          _analyticsCompaniesViewModel.objectAnalytics!.labels.length ==
              _analyticsCompaniesViewModel.objectAnalytics!.data.length) {
        int index = 0;

        _analyticsCompaniesViewModel.objectAnalytics?.labels.forEach((element) {
          items.add(PieChartModel(
              element,
              HexColor(generateRandomHexColor()),
              _analyticsCompaniesViewModel.objectAnalytics!.data[index]
                  .toDouble()));
          index++;
        });
      }
    }

    return items.isEmpty ? Container() : PieChartWidget(items: items);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _analyticsCompaniesViewModel = Provider.of<AnalyticsCompaniesViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      body: SizedBox.expand(
        child: Stack(children: [
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 24.0, bottom: _bottomPadding),
              children: [
                /// PRODUCT SELECTION
                SelectionInputWidget(
                  title: Titles.product,
                  value: _analyticsCompaniesViewModel.product?.name ??
                      Titles.notSelected,
                  isVertical: true,
                  onTap: () => _showSearchProductSheet(),
                ),

                _analyticsCompaniesViewModel.product == null
                    ? Container()
                    : _title(Titles.pledgetProductValue),

                /// PRODUCT SELECTION, TON'S
                // SelectionInputWidget(
                //     title: Titles.product,
                //     value: Titles.tonProductPlaceholder,
                //     isVertical: true,
                //     onTap: () => {}),

                /// PRODUCT HORIZONTAL CHART
                _analyticsCompaniesViewModel.productAnalytics == null
                    ? Container()
                    : HorizontalChartWidget(
                        labels: _analyticsCompaniesViewModel
                            .productAnalytics!.labels,
                        values: _analyticsCompaniesViewModel
                            .productAnalytics!.pledged,
                        onMaxScrollExtent: () => {}),
                SizedBox(
                    height: _analyticsCompaniesViewModel.product == null
                        ? 0.0
                        : 24.0),

                _analyticsCompaniesViewModel.productAnalytics == null
                    ? Container()
                    : _title(Titles.realizedProductValue),

                /// PRODUCT SELECTION, LITERS
                // SelectionInputWidget(
                //     title: Titles.product,
                //     value: Titles.literProductPlaceholder,
                //     isVertical: true,
                //     onTap: () => {}),
                _analyticsCompaniesViewModel.productAnalytics == null
                    ? Container()
                    : HorizontalChartWidget(
                        labels: _analyticsCompaniesViewModel
                            .productAnalytics!.labels,
                        values:
                            _analyticsCompaniesViewModel.productAnalytics!.sold,
                        onMaxScrollExtent: () => {}),
                SizedBox(
                    height: _analyticsCompaniesViewModel.product == null
                        ? 0.0
                        : 24.0),

                /// COMPANY PIE CHART
                _analyticsCompaniesViewModel.companyAnalytics == null
                    ? Container()
                    : _title(Titles.companyTotal),
                _companyPieChart(),
                const SizedBox(height: 24.0),

                /// OBJECT PIE CHART
                _analyticsCompaniesViewModel.objectAnalytics == null
                    ? Container()
                    : _title(Titles.objectTotal),

                _objectPieChart(),
                const SizedBox(height: 24.0),

                /// OBJECT TOTAL COUNT
                _analyticsCompaniesViewModel.objectAnalytics == null
                    ? Container()
                    : _title(Titles.dealTotal),

                /// FILIAL SELECTION
                SelectionInputWidget(
                    title: Titles.filial,
                    value: _analyticsCompaniesViewModel.office?.name ??
                        Titles.notSelected,
                    isVertical: true,
                    onTap: () => _showSearchOfficeSheet(false)),
                SizedBox(
                    height: _analyticsCompaniesViewModel.office == null
                        ? 0.0
                        : 16.0),
                _analyticsCompaniesViewModel.office == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Text(
                          _analyticsCompaniesViewModel.dealCount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: HexColors.additionalViolet,
                            fontSize: 32.0,
                            fontFamily: 'PT Root UI',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                _analyticsCompaniesViewModel.office == null
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 26.0),
                        child: Text(
                          Titles.dealTotalCount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: HexColors.grey50,
                            fontSize: 14.0,
                            fontFamily: 'PT Root UI',
                          ),
                        ),
                      ),

                /// MANAGER TOTAL LIST
                _title(Titles.managerTotal),

                /// FILIAL SELECTION
                SelectionInputWidget(
                  title: Titles.filial,
                  value: _analyticsCompaniesViewModel.managerOffice?.name ??
                      Titles.notSelected,
                  isVertical: true,
                  onTap: () => _showSearchOfficeSheet(true),
                ),
                const SizedBox(height: 20.0),

                /// EMPTY LIST TEXT
                _analyticsCompaniesViewModel.managerOffice == null
                    ? Container()
                    : _analyticsCompaniesViewModel.managerAnalytics == null
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            height: 120.0,
                            child: const NoResultTitle())
                        : _analyticsCompaniesViewModel
                                .managerAnalytics!.users.isEmpty
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                height: 120.0,
                                child: const NoResultTitle())
                            :

                            /// MANAGER LIST
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: _analyticsCompaniesViewModel
                                    .managerAnalytics?.users.length,
                                itemBuilder: (context, index) {
                                  final user = _analyticsCompaniesViewModel
                                      .managerAnalytics?.users[index];

                                  return AnalitycsManagerListItemWidget(
                                    key: ValueKey(user?.id),
                                    user: user,
                                    value: _analyticsCompaniesViewModel
                                            .managerAnalytics?.efficiency[index]
                                            .toDouble() ??
                                        0.0,
                                    onTap: () => _showProfileScreen(index),
                                  );
                                }),
              ]),

          /// INDICATOR
          _analyticsCompaniesViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showSearchOfficeSheet(bool isManagerOffice) {
    Office? newOffice;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchOfficeScreenWidget(
          isRoot: true,
          title: Titles.filial,
          onFocus: () => {},
          onPop: (office) => {
                newOffice = office,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _analyticsCompaniesViewModel.changeOffice(
          newOffice,
          isManagerOffice,
        ));
  }

  void _showSearchProductSheet() {
    Product? newProduct;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchProductScreenWidget(
          isRoot: true,
          title: Titles.product,
          onFocus: () => {},
          onPop: (product) => {
                Navigator.pop(context),
                newProduct = product,
              }),
    ).whenComplete(
        () => _analyticsCompaniesViewModel.changeProduct(newProduct));
  }

  void _showProfileScreen(int index) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
            isMine: false,
            user: _analyticsCompaniesViewModel.managerAnalytics!.users[index],
            onPop: (user) => null,
          ),
        ),
      );
}
