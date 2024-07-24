import 'package:flutter/material.dart';
import 'package:izowork/features/products/view_model/products_view_model.dart';

import 'package:izowork/features/products/view/products_screen_body.dart';
import 'package:provider/provider.dart';

class ProductsScreenWidget extends StatelessWidget {
  const ProductsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsViewModel(),
      child: const ProductsScreenBodyWidget(),
    );
  }
}
