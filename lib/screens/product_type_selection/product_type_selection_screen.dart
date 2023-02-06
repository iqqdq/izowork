import 'package:flutter/material.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/models/product_type_selection_view_model.dart';
import 'package:izowork/screens/product_type_selection/product_type_selection_screen_body.dart';
import 'package:provider/provider.dart';

class ProductTypeSelectionScreenWidget extends StatelessWidget {
  final ProductType? productType;
  final Function(ProductType?) onSelect;

  const ProductTypeSelectionScreenWidget(
      {Key? key, this.productType, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductTypeSelectionViewModel(productType),
        child: ProductTypeSelectionScreenBodyWidget(onSelect: onSelect));
  }
}