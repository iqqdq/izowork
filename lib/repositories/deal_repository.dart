import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/deal_create_request.dart';
import 'package:izowork/entities/request/deal_file_request.dart';
import 'package:izowork/entities/request/deal_process_request.dart';
import 'package:izowork/entities/request/deal_product_request.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/deal_process.dart';
import 'package:izowork/entities/response/deal_stage.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class DealRepository {
  Future<dynamic> getDeal(String id) async {
    dynamic json = await WebService().get(dealUrl + id);

    try {
      return Deal.fromJson(json["deal"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getDeals(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        dealsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

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
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getStage(String id) async {
    dynamic json = await WebService().get(dealStageUrl + id);
    List<DealStage> dealStages = [];

    try {
      json['stages'].forEach((element) {
        dealStages.add(DealStage.fromJson(element));
      });
      return dealStages;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createDeal(DealCreateRequest dealCreateRequest) async {
    dynamic json = await WebService().post(dealCreateUrl, dealCreateRequest);

    try {
      return Deal.fromJson(json["deal"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateDeal(DealCreateRequest dealCreateRequest) async {
    dynamic json = await WebService().patch(dealUpdateUrl, dealCreateRequest);

    try {
      return Deal.fromJson(json["deal"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getYearDeals({required List<String> params}) async {
    var url = dealsUrl + '?';

    for (var element in params) {
      url += element;
    }

    dynamic json = await WebService().get(url);
    List<Deal> deals = [];

    try {
      json['deals'].forEach((element) {
        deals.add(Deal.fromJson(element));
      });
      return deals;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getProduts(String id) async {
    dynamic json = await WebService().get(dealProductUrl + '?deal_id=$id');
    List<DealProduct> dealProducts = [];

    try {
      json['products'].forEach((element) {
        dealProducts.add(DealProduct.fromJson(element));
      });
      return dealProducts;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> addProduct(DealProductRequest dealProductRequest) async {
    dynamic json = await WebService().post(dealProductUrl, dealProductRequest);

    try {
      return DealProduct.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateProduct(DealProductRequest dealProductRequest) async {
    dynamic json = await WebService().patch(dealProductUrl, dealProductRequest);

    try {
      return DealProduct.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteProduct(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(dealProductUrl, deleteRequest);

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
    }
  }

  Future<dynamic> addDealFile(DealFileRequest dealFileRequest) async {
    dynamic json = await WebService()
        .postFormData(dealFileUrl, await dealFileRequest.toFormData());

    try {
      return Document.fromJson(json["deal_file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteDealFile(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(dealFileUrl, deleteRequest);

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
    }
  }

  Future<dynamic> getProcesses(String id) async {
    dynamic json =
        await WebService().get(dealProcessUrl + '?deal_stage_id=$id');
    List<DealProcess> dealProcesses = [];

    try {
      json['processes'].forEach((element) {
        dealProcesses.add(DealProcess.fromJson(element));
      });
      return dealProcesses;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateProcess(DealProcessRequest dealProcessRequest) async {
    dynamic json = await WebService().patch(dealProcessUrl, dealProcessRequest);

    try {
      return DealProcess.fromJson(json["process"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
