import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/products/views/product_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ProductsScreenBodyWidget extends StatefulWidget {
  const ProductsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ProductsScreenBodyState createState() => _ProductsScreenBodyState();
}

class _ProductsScreenBodyState extends State<ProductsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  late ProductsViewModel _productsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _productsViewModel.getProductList(
            pagination: _pagination, search: _textEditingController.text);
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

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    await _productsViewModel.getProductList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _productsViewModel = Provider.of<ProductsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            toolbarHeight: 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: HexColors.white90,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.products,
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
                                  EasyDebounce.debounce('product_debouncer',
                                      const Duration(milliseconds: 500),
                                      () async {
                                    _pagination =
                                        Pagination(offset: 0, size: 50);

                                    _productsViewModel
                                        .getProductList(
                                          pagination: _pagination,
                                          search: _textEditingController.text,
                                        )
                                        .then((value) => setState(
                                              () => _isSearching = false,
                                            ));
                                  })
                                },
                            onClearTap: () => {
                                  _productsViewModel.resetFilter(),
                                  _pagination.offset = 0,
                                  _productsViewModel.getProductList(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// PRODUCTS LIST VIEW
          LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 80.0 + MediaQuery.of(context).padding.bottom,
                  ),
                  itemCount: _productsViewModel.products.length,
                  itemBuilder: (context, index) {
                    return ProductsListItemWidget(
                      key: ValueKey(_productsViewModel.products[index].id),
                      tag: index.toString(),
                      product: _productsViewModel.products[index],
                      onTap: () => _productsViewModel.showProductPageViewScreen(
                        context,
                        index,
                      ),
                    );
                  })),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                      onTap: () => _productsViewModel.showProductFilterSheet(
                          context,
                          () => {
                                _pagination = Pagination(offset: 0, size: 50),
                                _productsViewModel.getProductList(
                                    pagination: _pagination,
                                    search: _textEditingController.text)
                              })))),

          /// EMPTY LIST TEXT
          _productsViewModel.loadingStatus == LoadingStatus.completed &&
                  _productsViewModel.products.isEmpty &&
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

          /// INDICATOR
          _productsViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: LoadingIndicatorWidget())
              : Container()
        ])));
  }
}
