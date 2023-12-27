import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/objects_view_model.dart';
import 'package:izowork/screens/analytics/views/analitics_object_list_item_widget.dart';
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
  Pagination _pagination = Pagination(offset: 0, size: 50);

  late ObjectsViewModel _objectsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _bottomPadding = MediaQuery.of(context).padding.bottom == 0.0
        ? 12.0
        : MediaQuery.of(context).padding.bottom;

    _objectsViewModel = Provider.of<ObjectsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        body: SizedBox.expand(
            child: Stack(children: [
          /// OBJECT LIST
          // Column(children: [
          // Container(
          //   padding:
          //       const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         SortObjectButtonWidget(
          //             title: Titles.object,
          //             imagePath: 'assets/ic_sort_object.svg',
          //             onTap: () => _objectsViewModel.sortByName().then(
          //                 (value) => _objectsViewModel.getObjectList(
          //                     pagination: _pagination, search: ''))),
          //         SortObjectButtonWidget(
          //             title: Titles.effectiveness,
          //             imagePath: 'assets/ic_sort_effectiveness.svg',
          //             onTap: () => _objectsViewModel.sortByEfficiency().then(
          //                 (value) => _objectsViewModel.getObjectList(
          //                     pagination: _pagination, search: ''))),
          //       ]),
          // ),
          // Expanded(
          // child:
          ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16.0, bottom: _bottomPadding),
              shrinkWrap: true,
              itemCount: _objectsViewModel.objects.length,
              itemBuilder: (context, index) {
                return AnalitycsObjectListItemWidget(
                  key: ValueKey(_objectsViewModel.objects[index]),
                  object: _objectsViewModel.objects[index],
                  onTap: () => _objectsViewModel.showObjectPageViewScreen(
                      context, index),
                );
              }),
          // )]),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: FilterButtonWidget(
                        onTap: () => _objectsViewModel.showObjectsFilterSheet(
                            context,
                            () => {
                                  _pagination = Pagination(offset: 0, size: 50),
                                  _objectsViewModel.getObjectList(
                                      pagination: _pagination, search: '')
                                }),
                        // onClearTap: () => {}
                      )))),

          /// EMPTY LIST TEXT
          _objectsViewModel.loadingStatus == LoadingStatus.completed &&
                  _objectsViewModel.objects.isEmpty
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// INDICATOR
          _objectsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
