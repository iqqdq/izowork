import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepositoryInterface {
  @override
  Future<dynamic> getCompanyTypes() async {
    dynamic json = await sl<WebServiceInterface>().get(companyTypesUrl);

    try {
      return CompanyType.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getCompany(String id) async {
    dynamic json = await sl<WebServiceInterface>().get(companyUrl + '?id=$id');

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createCompany(CompanyRequest companyRequest) async {
    debugPrint('${companyRequest.lat}, ${companyRequest.long}');

    dynamic json = await sl<WebServiceInterface>().post(
      companyCreateUrl,
      companyRequest.toJson(),
    );

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateCompany(CompanyRequest companyRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      companyUpdateUrl,
      companyRequest.toJson(),
      null,
    );

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateCompanyAvatar(FormData formData) async {
    dynamic json = await sl<WebServiceInterface>().put(
      companyAvatarUrl,
      formData,
    );

    if (json == "" || json == true) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
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

    dynamic json = await sl<WebServiceInterface>().get(url);
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

  @override
  Future<dynamic> createCompanyAction(
      CompanyActionRequest companyActionRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      companyActionCreateUrl,
      companyActionRequest.toJson(),
    );

    try {
      return CompanyAction.fromJson(json["action"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateCompanyAction(
      CompanyActionUpdateRequest companyActionUpdateRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      companyActionUpdateUrl,
      companyActionUpdateRequest.toJson(),
      null,
    );

    try {
      return CompanyAction.fromJson(json["action"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteCompanyAction(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      companyActionDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
