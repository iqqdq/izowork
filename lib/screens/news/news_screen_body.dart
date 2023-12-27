import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/news_view_model.dart';
import 'package:izowork/screens/news/views/news_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class NewsScreenBodyWidget extends StatefulWidget {
  const NewsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  late NewsViewModel _newsViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _newsViewModel.getNews(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _newsViewModel.getNews(
        pagination: _pagination, search: _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    _newsViewModel = Provider.of<NewsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.news,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  setState(() => _isSearching = true),
                                  _debouncer.run(() {
                                    _pagination =
                                        Pagination(offset: 0, size: 50);

                                    _newsViewModel
                                        .getNews(
                                            pagination: _pagination,
                                            search: _textEditingController.text)
                                        .then((value) => setState(
                                            () => _isSearching = false));
                                  })
                                },
                            onClearTap: () => {
                                  _newsViewModel.resetFilter(),
                                  _pagination.offset = 0,
                                  _newsViewModel.getNews(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                }))
              ])
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _newsViewModel.showNewsCreationScreen(
                context, _pagination, _textEditingController.text)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// NEWS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: _newsViewModel.news.length,
                  itemBuilder: (context, index) {
                    return NewsListItemWidget(
                      key: ValueKey(_newsViewModel.news[index].id),
                      tag: index.toString(),
                      news: _newsViewModel.news[index],
                      onTap: () => _newsViewModel.showNewsPageScreen(
                        context,
                        index,
                      ),
                      onUserTap: () => {},
                      onShowCommentsTap: () =>
                          _newsViewModel.showNewsCommentsScreen(context, index),
                    );
                  })),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _newsViewModel.loadingStatus == LoadingStatus.completed &&
                  _newsViewModel.news.isEmpty &&
                  !_isSearching
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

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: FilterButtonWidget(
                        onTap: () => _newsViewModel.showNewsFilterSheet(
                            context,
                            () => {
                                  _pagination = Pagination(offset: 0, size: 50),
                                  _newsViewModel.getNews(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                })),
                    // onClearTap: () => {}
                  ))),

          /// INDICATOR
          _newsViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: LoadingIndicatorWidget())
              : Container()
        ])));
  }
}
