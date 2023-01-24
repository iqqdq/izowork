import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AnalyticsCompaniesViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - PUSH

  void showSearchScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchScreenWidget(
            isRoot: true,
            searchType: SearchType.product,
            onPop: () => {
                  // TODO SET PRODUCT
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS
}
