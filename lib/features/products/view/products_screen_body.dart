import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/products/view_model/products_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/product/view/product_screen.dart';
import 'package:izowork/features/products/view/products_filter_sheet/products_filter_page_view_screen.dart';
import 'package:izowork/features/products/view/views/product_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  Pagination _pagination = Pagination();

  bool _isSearching = false;

  late ProductsViewModel _productsViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
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

  @override
  Widget build(BuildContext context) {
    _productsViewModel = Provider.of<ProductsViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: HexColors.white,
      appBar: AppBar(
          toolbarHeight: 116.0,
          titleSpacing: 0.0,
          backgroundColor: HexColors.white90,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Column(children: [
            Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: BackButtonWidget(onTap: () => Navigator.pop(context))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(Titles.products,
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 18.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold,
                    )),
              ])
            ]),
            const SizedBox(height: 16.0),
            Row(children: [
              /// SEARCH INPUT
              Expanded(
                  child: InputWidget(
                      textEditingController: _textEditingController,
                      focusNode: _focusNode,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      isSearchInput: true,
                      placeholder: '${Titles.search}...',
                      onTap: () => setState,
                      onChange: (text) => {
                            setState(() => _isSearching = true),
                            EasyDebounce.debounce('product_debouncer',
                                const Duration(milliseconds: 500), () async {
                              _pagination = Pagination();

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
                  final product = _productsViewModel.products[index];

                  return ProductsListItemWidget(
                    key: ValueKey(_productsViewModel.products[index].id),
                    tag: index.toString(),
                    product: product,
                    onTap: () => _showProductPageViewScreen(product),
                  );
                }),
          ),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilterButtonWidget(
                isSelected: _productsViewModel.productsFilter != null,
                onTap: () => _showProductFilterSheet(),
              ),
            ),
          ),

          /// EMPTY LIST TEXT
          _productsViewModel.loadingStatus == LoadingStatus.completed &&
                  _productsViewModel.products.isEmpty &&
                  !_isSearching
              ? const NoResultTitle()
              : Container(),

          /// INDICATOR
          _productsViewModel.loadingStatus == LoadingStatus.searching ||
                  _isSearching
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
    await _productsViewModel.getProductList(
      pagination: _pagination,
      search: _textEditingController.text,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showProductPageViewScreen(Product product) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductScreenWidget(product: product)));

  void _showProductFilterSheet() => showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => ProductsFilterPageViewScreenWidget(
            productsFilter: _productsViewModel.productsFilter,
            onPop: (productsFilter) => {
                  productsFilter == null
                      ? _productsViewModel.resetFilter()
                      : _productsViewModel.setFilter(productsFilter),
                  _onRefresh(),
                }),
      );
}
