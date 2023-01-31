import 'dart:math';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/analytics_objects_view_model.dart';
import 'package:izowork/screens/analytics/views/analitics_object_list_item_widget.dart';
import 'package:izowork/screens/analytics/views/sort_orbject_button_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class AnalyticsObjectsScreenBodyWidget extends StatefulWidget {
  const AnalyticsObjectsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnalyticsObjectsScreenBodyState createState() =>
      _AnalyticsObjectsScreenBodyState();
}

class _AnalyticsObjectsScreenBodyState
    extends State<AnalyticsObjectsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late AnalyticsObjectsViewModel _analyticsObjectsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _analyticsObjectsViewModel =
        Provider.of<AnalyticsObjectsViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          /// OBJECT LIST
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 16.0, right: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SortObjectButtonWidget(
                          title: Titles.object,
                          imagePath: 'assets/ic_sort_object.svg',
                          onTap: () => {
                                // TODO SORT OBJECT
                              }),
                      SortObjectButtonWidget(
                          title: Titles.effectiveness,
                          imagePath: 'assets/ic_sort_effectiveness.svg',
                          onTap: () => {
                                // TODO SORT OBJECT BY EFFECTIVENESS
                              })
                    ]),
              ),
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: _bottomPadding),
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return AnalitycsObjectListItemWidget(
                          value: Random().nextInt(99).toDouble(),
                          onTap: () => {},
                        );
                      }))
            ],
          ),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                          onTap: () => _analyticsObjectsViewModel
                              .showAnalyticsObjectsFilterSheet(context)
                          // onClearTap: () => {}
                          )))),

          /// INDICATOR
          _analyticsObjectsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
