import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class CompanyActionRepository {
  Future<dynamic> getCompanyActions({
    required Pagination pagination,
    required String companyId,
    List<String>? params,
  }) async {
    var url = companyActionsUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}&company_id=$companyId';

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<CompanyAction> companyActions = [];

    try {
      json['actions'].forEach((element) {
        companyActions.add(CompanyAction.fromJson(element));
      });
      return companyActions;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createCompanyAction(
      CompanyActionRequest companyActionRequest) async {
    dynamic json = await WebService().post(
      companyActionCreateUrl,
      companyActionRequest.toJson(),
    );

    try {
      return CompanyAction.fromJson(json["action"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
