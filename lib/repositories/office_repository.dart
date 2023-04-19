import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class OfficeRepository {
  Future<dynamic> getOffices(
      {required Pagination pagination, String? search}) async {
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
