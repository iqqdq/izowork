import 'package:flutter/material.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/models/search_product_view_model.dart';
import 'package:izowork/screens/search_product/search_product_screen_body.dart';
import 'package:provider/provider.dart';

class SearchProductScreenWidget extends StatelessWidget {
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Product?) onPop;

  const SearchProductScreenWidget(
      {Key? key,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchProductViewModel(),
        child: SearchProductScreenBodyWidget(
            isRoot: isRoot, onFocus: onFocus, onPop: onPop));
  }
}
