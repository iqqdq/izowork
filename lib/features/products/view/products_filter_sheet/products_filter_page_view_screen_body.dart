import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/products/view_model/products_filter_view_model.dart';

import 'package:izowork/models/models.dart';

import 'package:izowork/features/product_type_selection/view/product_type_selection_screen.dart';
import 'package:izowork/features/products/view/products_filter_sheet/products_filter_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class ProductsFilter {
  final ProductType? productType;
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  ProductsFilter(this.productType, this.tags, this.tags2, this.params);
}

class ProductsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(ProductsFilter?) onPop;

  const ProductsFilterPageViewScreenBodyWidget({
    Key? key,
    required this.onPop,
  }) : super(key: key);

  @override
  _ProductsFilterPageViewScreenBodyState createState() =>
      _ProductsFilterPageViewScreenBodyState();
}

class _ProductsFilterPageViewScreenBodyState
    extends State<ProductsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late ProductsFilterViewModel _productsFilterViewModel;
  // bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    _productsFilterViewModel = Provider.of<ProductsFilterViewModel>(
      context,
      listen: true,
    );

    return Material(
        type: MaterialType.transparency,
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height * 0.9,
                  // _isSearching
                  //     ? MediaQuery.of(context).size.height * 0.9
                  //     : MediaQuery.of(context).padding.bottom == 0.0
                  //         ? 334.0
                  //         : 364.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ProductsFilterScreenWidget(
                          productType: _productsFilterViewModel.productType,
                          options: _productsFilterViewModel.options,
                          tags: _productsFilterViewModel.tags,
                          options2: _productsFilterViewModel.options2,
                          tags2: _productsFilterViewModel.tags2,
                          onTypeTap: () => {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                ),
                                // setState(() => _isSearching = true)
                              },
                          onTagTap: (index) =>
                              _productsFilterViewModel.sortByAlphabet(index),
                          onTag2Tap: (index) =>
                              _productsFilterViewModel.sortByCost(index),
                          onApplyTap: () => {
                                _productsFilterViewModel.apply((params) => {
                                      widget.onPop(ProductsFilter(
                                          _productsFilterViewModel.productType,
                                          _productsFilterViewModel.tags,
                                          _productsFilterViewModel.tags2,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _productsFilterViewModel.reset(() {
                                widget.onPop(null);
                                Navigator.pop(context);
                              })),
                      ProductTypeSelectionScreenWidget(
                          isRoot: false,
                          title: Titles.productType,
                          productType: _productsFilterViewModel.productType,
                          onSelect: (productType) => {
                                _productsFilterViewModel
                                    .setProductType(productType)
                                    .then((value) => {
                                          _pageController.animateToPage(
                                            0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          ),
                                          // setState(() => _isSearching = false)
                                        })
                              })
                    ],
                  ))
            ]));
  }
}
