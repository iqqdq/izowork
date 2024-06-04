import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/search_user/views/search_user_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class ProductSelectionScreenBodyWidget extends StatefulWidget {
  final String title;
  final Function(Product?) onPop;

  const ProductSelectionScreenBodyWidget(
      {Key? key, required this.title, required this.onPop})
      : super(key: key);

  @override
  _ProductSelectionScreenBodyState createState() =>
      _ProductSelectionScreenBodyState();
}

class _ProductSelectionScreenBodyState
    extends State<ProductSelectionScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;
  late ProductSelectionViewModel _productSelectionViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _productSelectionViewModel.getProductList(
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

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 0.9;

    _productSelectionViewModel = Provider.of<ProductSelectionViewModel>(
      context,
      listen: true,
    );

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 8.0),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(children: [
                          BackButtonWidget(
                            title: Titles.back,
                            onTap: () => widget.onPop(null),
                          ),
                          Center(child: TitleWidget(text: widget.title))
                        ])),
                    const SizedBox(height: 16.0),

                    /// SEARCH INPUT
                    InputWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        isSearchInput: true,
                        placeholder: '${Titles.search}...',
                        onTap: () => setState,
                        onChange: (text) => {
                              setState(() => _isSearching = true),
                              EasyDebounce.debounce('product_debouncer',
                                  const Duration(milliseconds: 500), () async {
                                _pagination = Pagination(offset: 0, size: 50);

                                _productSelectionViewModel
                                    .getProductList(
                                      pagination: _pagination,
                                      search: _textEditingController.text,
                                    )
                                    .then(
                                      (value) => setState(
                                        () => _isSearching = false,
                                      ),
                                    );
                              })
                            },
                        onClearTap: () => {
                              _pagination.offset = 0,
                              _productSelectionViewModel.getProductList(
                                  pagination: _pagination)
                            }),
                    const SizedBox(height: 16.0),

                    /// SEPARATOR
                    const SeparatorWidget(),

                    /// USER LIST VIEW
                    SizedBox(
                        height: _height - 86.0,
                        child: GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: ListView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  top: 12.0,
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: (MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom !=
                                              0.0
                                          ? MediaQuery.of(context)
                                              .viewInsets
                                              .bottom
                                          : MediaQuery.of(context)
                                                      .padding
                                                      .bottom ==
                                                  0.0
                                              ? 12.0
                                              : MediaQuery.of(context)
                                                  .padding
                                                  .bottom) +
                                      124.0,
                                ),
                                itemCount:
                                    _productSelectionViewModel.products.length,
                                itemBuilder: (context, index) {
                                  return SearchUserListItemWidget(
                                      key: ValueKey(_productSelectionViewModel
                                          .products[index].id),
                                      name: _productSelectionViewModel
                                          .products[index].name,
                                      onTap: () => {
                                            FocusScope.of(context).unfocus(),
                                            widget.onPop(
                                                _productSelectionViewModel
                                                    .products[index])
                                          });
                                })))
                  ]),

              /// EMPTY LIST TEXT
              _productSelectionViewModel.loadingStatus ==
                          LoadingStatus.completed &&
                      _productSelectionViewModel.products.isEmpty &&
                      !_isSearching
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50),
                        ),
                      ),
                    )
                  : Container(),

              /// INDICATOR
              _productSelectionViewModel.loadingStatus ==
                      LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ])));
  }
}
