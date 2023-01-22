import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/product_page/product_page_screen.dart';
import 'package:izowork/screens/products/products_filter_sheet/products_filter_page_view_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductsViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH

  void showProductPageViewScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductPageScreenWidget(tag: index.toString())));
  }

  void showProductFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ProuctsFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }
}
