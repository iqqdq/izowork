import 'package:flutter/material.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/products/products_screen_body.dart';
import 'package:provider/provider.dart';

class ProductsScreenWidget extends StatelessWidget {
  const ProductsScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductsViewModel(),
        child: const ProductsScreenBodyWidget());
  }
}
