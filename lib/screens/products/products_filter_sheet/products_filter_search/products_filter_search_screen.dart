import 'package:flutter/material.dart';
import 'package:izowork/models/productss_search_view_model.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_search/products_filter_search_screen_body.dart';
import 'package:provider/provider.dart';

class ProductsFilterSearchScreenWidget extends StatelessWidget {
  final VoidCallback onPop;

  const ProductsFilterSearchScreenWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsSearchViewModel(),
        child: ProductsFilterSearchBodyScreenWidget(onPop: onPop));
  }
}
