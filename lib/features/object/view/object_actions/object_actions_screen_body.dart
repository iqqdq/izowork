import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/object/view_model/object_actions_view_model.dart';

import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/news_page/view/news_page_screen.dart';
import 'package:izowork/features/action_create/view/action_create_screen.dart';
import 'package:izowork/features/object/view/object_actions/views/object_action_list_item_widget.dart';
import 'package:izowork/features/phase/view/phase_screen.dart';
import 'package:izowork/features/task/view/task_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenBodyWidget extends StatefulWidget {
  final VoidCallback onObjectTraceTap;

  const ObjectActionsScreenBodyWidget({
    Key? key,
    required this.onObjectTraceTap,
  }) : super(key: key);

  @override
  _ObjectActionsScreenBodyState createState() =>
      _ObjectActionsScreenBodyState();
}

class _ObjectActionsScreenBodyState extends State<ObjectActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  late ObjectActionsViewModel _objectActionsViewModel;

  Pagination _pagination = Pagination();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _objectActionsViewModel.getTraceList(pagination: _pagination);
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

    _objectActionsViewModel = Provider.of<ObjectActionsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      floatingActionButton:
          FloatingButtonWidget(onTap: () => _showTextViewSheetScreen()),
      body: SizedBox.expand(
        child: Stack(children: [
          const SeparatorWidget(),

          /// ACTION LIST
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 90.0
                        : MediaQuery.of(context).padding.bottom + 70.0,
                  ),
                  itemCount: _objectActionsViewModel.traces.length,
                  itemBuilder: (context, index) {
                    var trace = _objectActionsViewModel.traces[index];

                    return ObjectActionListItemWidget(
                      key: ValueKey(trace.id),
                      trace: trace,
                      onTap: () => _onTraceTap(trace),
                    );
                  })),

          /// EMPTY LIST TEXT
          _objectActionsViewModel.loadingStatus == LoadingStatus.completed &&
                  _objectActionsViewModel.traces.isEmpty
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _objectActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination();
    await _objectActionsViewModel.getTraceList(pagination: _pagination);
  }

  // MARK: -
  // MARK: - PUSH

  void _showTextViewSheetScreen() {
    String? trace;

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => TextViewSheetWidget(
              title: Titles.addAction,
              label: Titles.action,
              onTap: (text) => {
                trace = text,
                Navigator.pop(context),
              },
            )).whenComplete(
        () => _objectActionsViewModel.addObjectTrace(trace ?? ''));
  }

  void _onTraceTap(Trace trace) async {
    Widget? screen;

    if (trace.objectId != null) {
      widget.onObjectTraceTap();
    } else if (trace.phaseId != null) {
      screen = PhaseScreenWidget(id: trace.phaseId!);
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
