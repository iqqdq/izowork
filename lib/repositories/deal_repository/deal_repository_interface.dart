import 'package:dio/dio.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class DealRepositoryInterface {
  Future<dynamic> getDeal(String id);

  Future<dynamic> getDeals({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getDealCount(String id);

  Future<dynamic> getStage(String id);

  Future<dynamic> createDeal(DealRequest dealRequest);

  Future<dynamic> updateDeal(DealRequest dealRequest);

  Future<dynamic> getYearDeals({required List<String> params});

  Future<dynamic> getProduts(String id);

  Future<dynamic> addProduct(DealProductRequest dealProductRequest);

  Future<dynamic> updateProduct(DealProductRequest dealProductRequest);

  Future<dynamic> deleteProduct(DeleteRequest deleteRequest);

  Future<dynamic> addDealFile(DealFileRequest dealFileRequest);

  Future<dynamic> deleteDealFile(DeleteRequest deleteRequest);

  Future<dynamic> getProcesses(String id);

  Future<dynamic> updateProcess(
      DealProcessUpdateRequest dealProcessUpdateRequest);

  Future<dynamic> getProcessInformationById(String id);

  Future<dynamic> getProcessInformation(String id);

  Future<dynamic> createProcessInfo(
      DealProcessInfoRequest dealProcessInfoRequest);

  // Future<dynamic> updateProcessInfo(
  //     DealProcessInfoRequest dealProcessInfoRequest.toJson());

  Future<dynamic> uploadProcessInfoFile(FormData formData);
}
