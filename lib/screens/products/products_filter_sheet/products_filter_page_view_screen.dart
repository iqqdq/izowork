import 'package:flutter/material.dart';
import 'package:izowork/models/products_filter_view_model.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_screen_body.dart';
import 'package:provider/provider.dart';

class ProductsFilterPageViewScreenWidget extends StatelessWidget {
  final ProductsFilter? productsFilter;
  final Function(ProductsFilter?) onPop;

  const ProductsFilterPageViewScreenWidget(
      {Key? key, this.productsFilter, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsFilterViewModel(productsFilter),
        child: ProductsFilterPageViewScreenBodyWidget(onPop: onPop));
  }
}
