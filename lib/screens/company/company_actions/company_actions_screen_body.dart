import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/screens/company/company_actions/views/company_action_list_item_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/screens/action_create/action_create_screen.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/notifiers/notifiers.dart';

class CompanyActionsScreenBodyWidget extends StatefulWidget {
  final String id;

  const CompanyActionsScreenBodyWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _CompanyActionsScreenBodyState createState() =>
      _CompanyActionsScreenBodyState();
}

class _CompanyActionsScreenBodyState
    extends State<CompanyActionsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);

  late CompanyActionsViewModel _companyActionsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _companyActionsViewModel.getCompanyActions(pagination: _pagination);
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

    _companyActionsViewModel = Provider.of<CompanyActionsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white,
      floatingActionButton:
          FloatingButtonWidget(onTap: () => _showActionCreateScreen()),
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
                itemCount: _companyActionsViewModel.companyActions.length,
                itemBuilder: (context, index) {
                  var companyAction =
                      _companyActionsViewModel.companyActions[index];

                  return CompanyActionListItemWidget(
                      key: ValueKey(companyAction.id),
                      companyAction: companyAction);
                }),
          ),

          /// EMPTY LIST TEXT
          _companyActionsViewModel.loadingStatus == LoadingStatus.completed &&
                  _companyActionsViewModel.companyActions.isEmpty
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
          _companyActionsViewModel.loadingStatus == LoadingStatus.searching
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
    await _companyActionsViewModel.getCompanyActions(pagination: _pagination);
  }

  // MARK: -
  // MARK: - PUSH

  void _showActionCreateScreen() => showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => ActionCreateSheetWidget(
            onTap: (text) => {
              Navigator.pop(context),
              _companyActionsViewModel.addCompanyAction(text)
            },
          ));
}
