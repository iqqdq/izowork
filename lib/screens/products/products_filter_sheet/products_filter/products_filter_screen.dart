import 'package:flutter/material.dart';
import 'package:izowork/models/products_filter_view_model.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter/products_filter_screen_body.dart';
import 'package:provider/provider.dart';

class ProductsFilterScreenWidget extends StatelessWidget {
  final VoidCallback onTypeTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ProductsFilterScreenWidget(
      {Key? key,
      required this.onTypeTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsFilterViewModel(),
        child: ProductsFilterScreenBodyWidget(
            onTypeTap: onTypeTap,
            onApplyTap: onApplyTap,
            onResetTap: onResetTap));
  }
}
