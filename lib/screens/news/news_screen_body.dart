import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
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
import 'package:provider/provider.dart';

class NewsScreenBodyWidget extends StatefulWidget {
  const NewsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _NewsScreenBodyState createState() => _NewsScreenBodyState();
}

class _NewsScreenBodyState extends State<NewsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late NewsViewModel _newsViewModel;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newsViewModel = Provider.of<NewsViewModel>(context, listen: true);

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
                                  // TODO SEARCH NEWS
                                },
                            onClearTap: () => {
                                  // TODO CLEAR NEWS SEARCH
                                }))
              ])
            ])),
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _newsViewModel.showNewsCreationScreen(context)),
        body: SizedBox.expand(
            child: Stack(children: [
          /// NEWS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom),
              itemCount: _newsViewModel.news.length,
              itemBuilder: (context, index) {
                return NewsListItemWidget(
                    tag: index.toString(),
                    news: _newsViewModel.news[index],
                    onTap: () =>
                        _newsViewModel.showNewsPageScreen(context, index),
                    onUserTap: () => {},
                    onShowCommentsTap: () =>
                        _newsViewModel.showNewsCommentsScreen(context, index));
              }),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FilterButtonWidget(
                        onTap: () =>
                            _newsViewModel.showContactsFilterSheet(context),
                        // onClearTap: () => {}
                      )))),

          /// INDICATOR
          _newsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
