import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepositoryInterface {
  @override
  Future<dynamic> getCompanyAnalytics() async {
    dynamic json = await sl<WebServiceInterface>().get(companyAnalyticsUrl);

    try {
      return CompanyAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getManagerAnalytics(String id) async {
    dynamic json = await sl<WebServiceInterface>()
        .get(managerAnalyticsUrl + '?office_id=$id');
    try {
      return ManagerAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getObjectAnalytics() async {
    dynamic json = await sl<WebServiceInterface>().get(objectAnalyticsUrl);

    try {
      return ObjectAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getProductAnalytics(String id, String? year) async {
    var url = productAnalyticsUrl + '?product_id=$id';

    if (year != null) {
      url += '&year=$year';
    }

    dynamic json = await sl<WebServiceInterface>().get(url);

    try {
      return ProductAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
