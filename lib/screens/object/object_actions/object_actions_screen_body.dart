import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/object_actions_view_model.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/object/object_actions/views/object_action_list_item_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ObjectActionsScreenBodyWidget extends StatefulWidget {
  const ObjectActionsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectActionsScreenBodyState createState() =>
      _ObjectActionsScreenBodyState();
}

class _ObjectActionsScreenBodyState
    extends State<ObjectActionsScreenBodyWidget> {
  final ScrollController _scrollController = ScrollController();

  late ObjectActionsViewModel _objectActionsViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _objectActionsViewModel.getTraceList(pagination: _pagination);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _objectActionsViewModel.getTraceList(pagination: _pagination);
  }

  @override
  Widget build(BuildContext context) {
    _objectActionsViewModel = Provider.of<ObjectActionsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        floatingActionButton: FloatingButtonWidget(
          onTap: () => _objectActionsViewModel.showActionCreateScreen(
            context,
            _pagination,
          ),
        ),
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
                    return ObjectActionListItemWidget(
                        key: ValueKey(_objectActionsViewModel.traces[index].id),
                        trace: _objectActionsViewModel.traces[index],
                        onTap: () => _objectActionsViewModel.showTraceScreen(
                              context,
                              index,
                            ));
                  })),

          /// INDICATOR
          _objectActionsViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: LoadingIndicatorWidget())
              : Container()
        ])));
  }
}
