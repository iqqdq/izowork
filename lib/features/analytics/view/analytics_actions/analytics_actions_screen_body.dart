import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/analytics/view_model/analytics_actions_view_model.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/analytics/view/views/analitics_action_list_item_widget.dart';
import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/news_page/view/news_page_screen.dart';
import 'package:izowork/features/object/view/object_page_view_screen.dart';
import 'package:izowork/features/task/view/task_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen.dart';

class AnalyticsActionsScreenBodyWidget extends StatefulWidget {
  const AnalyticsActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnalyticsActionsScreenBodyState createState() =>
      _AnalyticsActionsScreenBodyState();
}

class _AnalyticsActionsScreenBodyState
    extends State<AnalyticsActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final Pagination _pagination = Pagination();

  late AnalyticsActionsViewModel _analyticsActionsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _analyticsActionsViewModel.getTraceList(pagination: _pagination);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _analyticsActionsViewModel = Provider.of<AnalyticsActionsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      body: SizedBox.expand(
        child: Stack(children: [
          /// ACTION LIST
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                padding: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).padding.bottom == 0.0
                            ? 12.0
                            : MediaQuery.of(context).padding.bottom) +
                        64.0),
                shrinkWrap: true,
                itemCount: _analyticsActionsViewModel.traces.length,
                itemBuilder: (context, index) {
                  final trace = _analyticsActionsViewModel.traces[index];

                  return AnalitycsActionListItemWidget(
                    key: ValueKey(trace.id),
                    trace: trace,
                    onTap: () => _onTraceTap(trace),
                  );
                }),
          ),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected:
                    _analyticsActionsViewModel.analyticsActionsFilter != null,
                onTap: () => _showAnalyticsActionFilterSheet(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _analyticsActionsViewModel.loadingStatus == LoadingStatus.completed &&
                  _analyticsActionsViewModel.traces.isEmpty
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _analyticsActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination.reset();
    await _analyticsActionsViewModel.getTraceList(pagination: _pagination);
  }

  // MARK: -
  // MARK: - PUSH

  void _showAnalyticsActionFilterSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => AnalyticsActionsFilterPageViewScreenWidget(
            analyticsActionsFilter:
                _analyticsActionsViewModel.analyticsActionsFilter,
            onPop: (analyticsActionsFilter) => {
                  analyticsActionsFilter == null
                      ? {
                          _analyticsActionsViewModel.resetFilter(),
                          _onRefresh(),
                        }
                      : _analyticsActionsViewModel.setFilter(
                          '',
                          analyticsActionsFilter,
                        ),
                }),
      );

  void _onTraceTap(Trace trace) {
    Widget? screen;

    if (trace.objectId != null) {
      if (trace.phaseId != null) {
        screen = ObjectPageViewScreenWidget(
          id: trace.objectId!,
          phaseId: trace.phaseId,
          onPop: (object) {},
        );
      } else {
        screen = ObjectPageViewScreenWidget(
          id: trace.objectId!,
          onPop: (object) {},
        );
      }
    } else if (trace.dealId != null) {
      screen = DealScreenWidget(id: trace.dealId!);
    } else if (trace.taskId != null) {
      screen = TaskScreenWidget(id: trace.taskId!);
    } else if (trace.newsId != null) {
      screen = NewsPageScreenWidget(id: trace.newsId!);
    }

    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen!));
  }
}
