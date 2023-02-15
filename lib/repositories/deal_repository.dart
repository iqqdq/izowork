import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class DealRepository {
  Future<dynamic> getDeal(String id) async {
    dynamic json = await WebService().get(dealUrl + id);

    try {
      return Deal.fromJson(json["deal"]);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }

  Future<dynamic> getDeals(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        dealsUrl + '?&offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Deal> deals = [];

    try {
      json['deals'].forEach((element) {
        deals.add(Deal.fromJson(element));
      });
      return deals;
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }
}
