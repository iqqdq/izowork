// ignore_for_file: annotate_overrides

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'office_repository_repository_interface.dart';

class OfficeRepositoryImpl implements OfficeRepositoryInterface {
  Future<dynamic> getOffices({
    required Pagination pagination,
    String? search,
  }) async {
    var url =
        officeUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Office> offices = [];

    try {
      json['offices'].forEach((element) {
        offices.add(Office.fromJson(element));
      });
      return offices;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
