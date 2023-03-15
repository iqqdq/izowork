import 'package:dio/dio.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/company_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/company_type.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class CompanyRepository {
  Future<dynamic> getCompanyTypes() async {
    dynamic json = await WebService().get(companyTypesUrl);

    try {
      return CompanyType.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getCompany(String id) async {
    dynamic json = await WebService().get(companiesUrl + '?id=$id');

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getCompanies(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        companiesUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Company> companies = [];

    try {
      json['companies'].forEach((element) {
        companies.add(Company.fromJson(element));
      });
      return companies;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createCompany(CompanyRequest companyRequest) async {
    dynamic json = await WebService().post(companyCreateUrl, companyRequest);

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateCompanyAvatar(FormData formData) async {
    dynamic json = await WebService().put(companyAvatarUrl, formData);

    if (json == "") {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
