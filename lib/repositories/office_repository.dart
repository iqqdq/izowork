import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class OfficeRepository {
  Future<dynamic> getOffices({
    required Pagination pagination,
    String? search,
  }) async {
    var url =
        officeUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search != null) {
      url += '&q=$search';
    }

    dynamic json = await WebService().get(url);
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
