import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'companies_repository_interface.dart';

class CompaniesRepositoryImpl implements CompaniesRepositoryInterface {
  @override
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

    dynamic json = await sl<WebServiceInterface>().get(url);
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

  @override
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

    dynamic json = await sl<WebServiceInterface>().get(url);
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
}
