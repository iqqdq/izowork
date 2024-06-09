import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/analytics/views/analitics_object_list_item_widget.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen.dart';
import 'package:izowork/views/views.dart';

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

    _objectsViewModel = Provider.of<ObjectsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      body: SizedBox.expand(
        child: Stack(children: [
          /// OBJECT LIST

          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0.0
                      ? 80.0
                      : MediaQuery.of(context).padding.bottom + 60.0,
                ),
                shrinkWrap: true,
                itemCount: _objectsViewModel.objects.length,
                itemBuilder: (context, index) {
                  return AnalitycsObjectListItemWidget(
                    key: ValueKey(_objectsViewModel.objects[index]),
                    object: _objectsViewModel.objects[index],
                    onTap: () => _showObjectPageViewScreen(index),
                  );
                }),
          ),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _objectsViewModel.objectsFilter != null,
                onTap: () => _showObjectsFilterSheet(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _objectsViewModel.loadingStatus == LoadingStatus.completed &&
                  _objectsViewModel.objects.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      Titles.noResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: HexColors.grey50,
                      ),
                    ),
                  ),
                )
              : Container(),

          /// INDICATOR
          _objectsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _objectsViewModel.getObjectList(
      pagination: _pagination,
      search: '',
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showObjectsFilterSheet() {
    if (_objectsViewModel.objectStages == null) return;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => ObjectsFilterPageViewScreenWidget(
          objectStages: _objectsViewModel.objectStages!,
          objectsFilter: _objectsViewModel.objectsFilter,
          onPop: (objectsFilter) => {
                objectsFilter == null
                    ? _objectsViewModel.resetFilter()
                    : _objectsViewModel.setFilter(objectsFilter),
                _onRefresh(),
              }),
    );
  }

  void _showObjectPageViewScreen(int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ObjectPageViewScreenWidget(
                id: _objectsViewModel.objects[index].id,
                onPop: (object) {},
              )));
}
