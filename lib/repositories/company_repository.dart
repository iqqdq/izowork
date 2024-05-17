import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
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
    dynamic json = await WebService().get(companyUrl + '?id=$id');

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getCompanies({
    required Pagination pagination,
    required String search,
    List<String>? params,
  }) async {
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

  Future<dynamic> getMapCompanies({
    required List<String> params,
    required LatLngBounds? visibleRegion,
  }) async {
    var url = companiesUrl;

    if (visibleRegion != null) {
      url +=
          '?lat=gte:${visibleRegion.southwest.latitude}&lat=lte:${visibleRegion.northeast.latitude}&long=gte:${visibleRegion.southwest.longitude}&long=lte:${visibleRegion.northeast.longitude}';
    }

    if (params.isNotEmpty) {
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
    debugPrint('${companyRequest.lat}, ${companyRequest.long}');

    dynamic json = await WebService().post(
      companyCreateUrl,
      companyRequest.toJson(),
    );

    try {
      return Company.fromJson(json["company"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateCompany(CompanyRequest companyRequest) async {
    dynamic json = await WebService().patch(
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

  Future<dynamic> updateCompanyAvatar(FormData formData) async {
    dynamic json = await WebService().put(
      companyAvatarUrl,
      formData,
    );

    if (json == "" || json == true) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
