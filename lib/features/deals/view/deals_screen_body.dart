import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/features/deals/view_model/deals_view_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';

import 'package:izowork/features/deal/view/deal_screen.dart';
import 'package:izowork/features/deal_calendar/view/deal_calendar_screen.dart';
import 'package:izowork/features/deal_create/view/deal_create_screen.dart';
import 'package:izowork/features/deals/view/deals_filter_sheet/deals_filter_page_view_screen.dart';
import 'package:izowork/features/deals/view/views/deal_list_item_widget.dart';
import 'package:izowork/views/views.dart';

class DealsScreenBodyWidget extends StatefulWidget {
  const DealsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _DealsScreenBodyState createState() => _DealsScreenBodyState();
}

class _DealsScreenBodyState extends State<DealsScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Pagination _pagination = Pagination();
  bool _isSearching = false;

  late DealsViewModel _dealsViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _dealsViewModel.getDealList(
          pagination: _pagination,
          search: _textEditingController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _dealsViewModel = Provider.of<DealsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 74.0,
          titleSpacing: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(children: [
            const SizedBox(height: 12.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(children: [
                  Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin: const EdgeInsets.only(right: 18.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  setState(() => _isSearching = true),
                                  EasyDebounce.debounce('deal_debouncer',
                                      const Duration(milliseconds: 500),
                                      () async {
                                    _pagination = Pagination();

                                    _dealsViewModel
                                        .getDealList(
                                          pagination: _pagination,
                                          search: _textEditingController.text,
                                        )
                                        .then((value) => setState(
                                              () => _isSearching = false,
                                            ));
                                  })
                                },
                            onClearTap: () => {
                                  _dealsViewModel.resetFilter(),
                                  _onRefresh(),
                                }),
                  ),

                  /// CALENDAR BUTTON
                  AssetImageButton(
                    imagePath: 'assets/ic_calendar.svg',
                    onTap: () => _showCalendarScreen(),
                  )
                ])),
            const SizedBox(height: 16.0),
            const SeparatorWidget()
          ]),
        ),
        floatingActionButton:
            FloatingButtonWidget(onTap: () => _showDealCreateScreen()),
        body: SizedBox.expand(
            child: Stack(children: [
          /// TASKS LIST VIEW
          LiquidPullToRefresh(
            color: HexColors.primaryMain,
            backgroundColor: HexColors.white,
            springAnimationDurationInMilliseconds: 300,
            onRefresh: _onRefresh,
            child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 16.0 + 48.0,
                ),
                itemCount: _dealsViewModel.deals.length,
                itemBuilder: (context, index) {
                  final deal = _dealsViewModel.deals[index];

                  return DealListItemWidget(
                    key: ValueKey(deal.id),
                    deal: deal,
                    onTap: () => _showDealScreenWidget(deal.id),
                  );
                }),
          ),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _dealsViewModel.dealsFilter != null,
                onTap: () => _showDealsFilterSheet(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _dealsViewModel.loadingStatus == LoadingStatus.completed &&
                  _dealsViewModel.deals.isEmpty &&
                  !_isSearching
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _dealsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination.reset();
    await _dealsViewModel.getDealList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showCalendarScreen() {
    FocusScope.of(context).unfocus();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCalendarScreenWidget()));
  }

  void _showDealCreateScreen() {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DealCreateScreenWidget(
            onCreate: (deal, dealProducts) => {
                  if (deal != null) _dealsViewModel.getDealById(deal.id),
                }),
      ),
    );
  }

  void _showDealsFilterSheet() {
    FocusScope.of(context).unfocus();

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DealsFilterPageViewScreenWidget(
            dealsFilter: _dealsViewModel.dealsFilter,
            onPop: (dealsFilter) => {
                  dealsFilter == null
                      ? {
                          _dealsViewModel.resetFilter(),
                          _onRefresh(),
                        }
                      : _dealsViewModel.setFilter(
                          '',
                          dealsFilter,
                        ),
                }));
  }

  void _showDealScreenWidget(String id) {
    FocusScope.of(context).unfocus();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DealScreenWidget(id: id)));
  }
}
