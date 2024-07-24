import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class AnalyticsCompaniesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  ProductAnalytics? _productAnalytics;

  ProductAnalytics? get productAnalytics => _productAnalytics;

  CompanyAnalytics? _companyAnalytics;

  CompanyAnalytics? get companyAnalytics => _companyAnalytics;

  ObjectAnalytics? _objectAnalytics;

  ObjectAnalytics? get objectAnalytics => _objectAnalytics;

  ManagerAnalytics? _managerAnalytics;

  ManagerAnalytics? get managerAnalytics => _managerAnalytics;

  Office? _office;

  Office? get office => _office;

  Office? _managerOffice;

  Office? get managerOffice => _managerOffice;

  Product? _product;

  Product? get product => _product;

  int _dealCount = 0;

  int get dealCount => _dealCount;

  AnalyticsCompaniesViewModel() {
    getCompanyPieChart();
  }

  // MARK: -
  // MARK: - API CALL

  Future getProductChart(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<AnalyticsRepositoryInterface>()
        .getProductAnalytics(id, DateTime.now().year.toString())
        .then((response) => {
              if (response is ProductAnalytics)
                {
                  loadingStatus = LoadingStatus.completed,
                  _productAnalytics = response
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future getCompanyPieChart() async {
    await sl<AnalyticsRepositoryInterface>()
        .getCompanyAnalytics()
        .then((response) => {
              if (response is CompanyAnalytics) _companyAnalytics = response,
            })
        .then((value) => getObjectPieChart());
  }

  Future getObjectPieChart() async {
    await sl<AnalyticsRepositoryInterface>()
        .getObjectAnalytics()
        .then((response) => {
              if (response is ObjectAnalytics)
                {
                  loadingStatus = LoadingStatus.completed,
                  _objectAnalytics = response
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future getDealCount(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .getDealCount(id)
        .then((response) => {
              if (response is int)
                {
                  loadingStatus = LoadingStatus.completed,
                  _dealCount = response,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future getManagerList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<AnalyticsRepositoryInterface>()
        .getManagerAnalytics(id)
        .then((response) => {
              if (response is ManagerAnalytics) _managerAnalytics = response,
            })
        .then(
          (value) => {
            loadingStatus = LoadingStatus.completed,
            notifyListeners(),
          },
        );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeOffice(
    Office? office,
    bool isManagerOffice,
  ) {
    if (office == null) return;

    if (isManagerOffice) {
      _managerOffice = office;
      getManagerList(office.id);
    } else {
      _office = office;
      getDealCount(office.id);
    }
  }

  void changeProduct(Product? product) {
    if (product == null) return;

    _product = product;
    getProductChart(product.id);
  }
}
