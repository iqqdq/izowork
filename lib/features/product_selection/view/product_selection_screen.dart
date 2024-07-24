import 'package:flutter/material.dart';
import 'package:izowork/features/product_selection/view_model/product_selection_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/product_selection/view/product_selection_screen_body.dart';
import 'package:provider/provider.dart';

class ProductSelectionScreenWidget extends StatelessWidget {
  final String title;
  final Function(Product?) onPop;

  const ProductSelectionScreenWidget(
      {Key? key, required this.title, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductSelectionViewModel(),
      child: ProductSelectionScreenBodyWidget(
        title: title,
        onPop: onPop,
      ),
    );
  }
}
