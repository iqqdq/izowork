import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class AnalyticsRepository {
  Future<dynamic> getCompanyAnalytics() async {
    dynamic json = await WebService().get(companyAnalyticsUrl);
    try {
      return CompanyAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getManagerAnalytics(String id) async {
    dynamic json =
        await WebService().get(managerAnalyticsUrl + '?office_id=$id');
    try {
      return ManagerAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getObjectAnalytics() async {
    dynamic json = await WebService().get(objectAnalyticsUrl);

    try {
      return ObjectAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getProductAnalytics(String id, String? year) async {
    var url = productAnalyticsUrl + '?product_id=$id';

    if (year != null) {
      url += '&year=$year';
    }

    dynamic json = await WebService().get(url);

    try {
      return ProductAnalytics.fromJson(json['analytics']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
