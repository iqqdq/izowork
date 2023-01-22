import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_widget.dart';
import 'package:izowork/screens/company/company_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CompaniesViewModel with ChangeNotifier {
  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH
  void showCompanyPageViewScreen(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CompanyScreenWidget()));
  }

  void showCompaniesFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => CompaniesFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }
}
