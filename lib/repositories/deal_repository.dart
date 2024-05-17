import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
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

  Future<dynamic> getDealCount(String id) async {
    dynamic json = await WebService().get(dealCountUrl + '?office_id=$id');

    try {
      return json['count'] as int;
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

  Future<dynamic> createDeal(DealRequest dealRequest) async {
    dynamic json = await WebService().post(
      dealCreateUrl,
      dealRequest.toJson(),
    );

    try {
      return Deal.fromJson(json["deal"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateDeal(DealRequest dealRequest) async {
    dynamic json = await WebService().patch(
      dealUpdateUrl,
      dealRequest.toJson(),
      null,
    );

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
    dynamic json = await WebService().post(
      dealProductUrl,
      dealProductRequest.toJson(),
    );

    try {
      return DealProduct.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateProduct(DealProductRequest dealProductRequest) async {
    dynamic json = await WebService().patch(
      dealProductUrl,
      dealProductRequest.toJson(),
      null,
    );

    try {
      return DealProduct.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteProduct(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      dealProductUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
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
    dynamic json = await WebService().delete(
      dealFileUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
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

  Future<dynamic> updateProcess(
      DealProcessUpdateRequest dealProcessUpdateRequest) async {
    dynamic json = await WebService().patch(
      dealProcessUrl,
      dealProcessUpdateRequest.toJson(),
      null,
    );

    try {
      return DealProcess.fromJson(json["process"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getProcessInformationById(String id) async {
    dynamic json = await WebService().get(dealProcessInfoOneUrl + '?id=$id');

    try {
      return DealProcessInfo.fromJson(json["information"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getProcessInformation(String id) async {
    dynamic json = await WebService()
        .get(dealProcessInfoUrl + '?deal_stage_process_id=$id');

    List<DealProcessInfo> informations = [];

    try {
      json['informations'].forEach((element) {
        informations.add(DealProcessInfo.fromJson(element));
      });
      return informations;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createProcessInfo(
      DealProcessInfoRequest dealProcessInfoRequest) async {
    dynamic json = await WebService().post(
      dealProcessInfoUrl,
      dealProcessInfoRequest.toJson(),
    );

    try {
      return DealProcessInfo.fromJson(json["information"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  // Future<dynamic> updateProcessInfo(
  //     DealProcessInfoRequest dealProcessInfoRequest.toJson(),) async {
  //   dynamic json =
  //       await WebService().patch(dealProcessInfoUrl, dealProcessInfoRequest.toJson(),);

  //   try {
  //     return DealProcessInfo.fromJson(json["information"]);
  //   } catch (e) {
  //     return ErrorResponse.fromJson(json);
  //   }
  // }

  Future<dynamic> uploadProcessInfoFile(FormData formData) async {
    dynamic json = await WebService().post(dealProcessInfoFileUrl, formData);

    try {
      return json["file"] as String;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
