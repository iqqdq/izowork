import 'package:flutter/material.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/search_product/search_product_screen_body.dart';
import 'package:provider/provider.dart';

class SearchProductScreenWidget extends StatelessWidget {
  final String? title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Product?) onPop;

  const SearchProductScreenWidget(
      {Key? key,
      this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchProductViewModel(),
        child: SearchProductScreenBodyWidget(
            title: title, isRoot: isRoot, onFocus: onFocus, onPop: onPop));
  }
}
