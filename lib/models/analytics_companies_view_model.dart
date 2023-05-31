import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company_analytics.dart';
import 'package:izowork/entities/response/manager_analytics.dart';
import 'package:izowork/entities/response/object_analytics.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/entities/response/product_analytics.dart';
import 'package:izowork/repositories/analytics_repository.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/search_office/search_office_screen.dart';
import 'package:izowork/screens/search_product/search_product_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AnalyticsCompaniesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  ProductAnalytics? _productAnalytics;

  CompanyAnalytics? _companyAnalytics;

  ObjectAnalytics? _objectAnalytics;

  ManagerAnalytics? _managerAnalytics;

  Office? _office;

  Office? _managerOffice;

  Product? _product;

  int _dealCount = 0;

  ProductAnalytics? get productAnalytics {
    return _productAnalytics;
  }

  CompanyAnalytics? get companyAnalytics {
    return _companyAnalytics;
  }

  ObjectAnalytics? get objectAnalytics {
    return _objectAnalytics;
  }

  ManagerAnalytics? get managerAnalytics {
    return _managerAnalytics;
  }

  Office? get office {
    return _office;
  }

  Office? get managerOffice {
    return _managerOffice;
  }

  Product? get product {
    return _product;
  }

  int get dealCount {
    return _dealCount;
  }

  AnalyticsCompaniesViewModel() {
    getCompanyPieChart();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductChart(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await AnalyticsRepository()
        .getProductAnalytics(id, DateTime.now().year.toString())
        .then((response) => {
              if (response is ProductAnalytics)
                {
                  loadingStatus = LoadingStatus.completed,
                  _productAnalytics = response
                }
            })
        .then((value) => notifyListeners());
  }

  Future getCompanyPieChart() async {
    await AnalyticsRepository()
        .getCompanyAnalytics()
        .then((response) => {
              if (response is CompanyAnalytics) {_companyAnalytics = response}
            })
        .then((value) => getObjectPieChart());
  }

  Future getObjectPieChart() async {
    await AnalyticsRepository()
        .getObjectAnalytics()
        .then((response) => {
              if (response is ObjectAnalytics)
                {
                  loadingStatus = LoadingStatus.completed,
                  _objectAnalytics = response
                }
            })
        .then((value) => notifyListeners());
  }

  Future getDealCount(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .getDealCount(id)
        .then((response) => {
              if (response is int)
                {loadingStatus = LoadingStatus.completed, _dealCount = response}
            })
        .then((value) => notifyListeners());
  }

  Future getManagerList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await AnalyticsRepository()
        .getManagerAnalytics(id)
        .then((response) => {
              if (response is ManagerAnalytics)
                {
                  loadingStatus = LoadingStatus.completed,
                  _managerAnalytics = response
                }
            })
        .then((value) => notifyListeners());
  }

  // MARK: -
  // MARK: - PUSH

  void showSearchOfficeSheet(BuildContext context, bool isManagerOffice) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchOfficeScreenWidget(
            isRoot: true,
            title: Titles.filial,
            onFocus: () => {},
            onPop: (office) => {
                  Navigator.pop(context),
                  if (office != null)
                    {
                      if (isManagerOffice)
                        {_managerOffice = office, getManagerList(office.id)}
                      else
                        {_office = office, getDealCount(office.id)}
                    }
                }));
  }

  void showSearchProductSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchProductScreenWidget(
            isRoot: true,
            title: Titles.product,
            onFocus: () => {},
            onPop: (product) => {
                  Navigator.pop(context),
                  if (product != null)
                    {
                      _product = product,
                      notifyListeners(),
                      getProductChart(product.id)
                    }
                }));
  }

  void showProfileScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreenWidget(
                isMine: false,
                user: _managerAnalytics!.users[index],
                onPop: (user) => null)));
  }
}
