import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/product_type_selection/product_type_selection_screen_body.dart';
import 'package:provider/provider.dart';

class ProductTypeSelectionScreenWidget extends StatelessWidget {
  final bool isRoot;
  final String title;
  final ProductType? productType;
  final Function(ProductType?) onSelect;

  const ProductTypeSelectionScreenWidget(
      {Key? key,
      required this.title,
      this.productType,
      required this.onSelect,
      required this.isRoot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductTypeSelectionViewModel(productType),
        child: ProductTypeSelectionScreenBodyWidget(
            isRoot: isRoot, title: title, onSelect: onSelect));
  }
}
