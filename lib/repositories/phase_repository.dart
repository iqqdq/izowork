import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class PhaseRepository {
  Future<dynamic> getPhases(String id) async {
    dynamic json = await WebService().get(phasesUrl + '?object_id=$id');
    List<Phase> phases = [];

    try {
      json['phases'].forEach((element) {
        phases.add(Phase.fromJson(element));
      });
      return phases;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhase(String id) async {
    dynamic json = await WebService().get('$phaseUrl?id=$id');

    try {
      return Phase.fromJson(json['phase']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseProducts(String id) async {
    dynamic json = await WebService().get(phaseProductsUrl + '?phase_id=$id');
    List<PhaseProduct> phaseProducts = [];

    try {
      json['phase_products'].forEach((element) {
        phaseProducts.add(PhaseProduct.fromJson(element));
      });
      return phaseProducts;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseDeals(String id) async {
    dynamic json = await WebService().get(dealsUrl + '?phase_id=$id');
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

  Future<dynamic> getPhaseContractors(String id) async {
    dynamic json =
        await WebService().get(phaseContractorsUrl + '?phase_id=$id');
    List<PhaseContractor> phaseContrators = [];

    try {
      json['phase_contractors'].forEach((element) {
        phaseContrators.add(PhaseContractor.fromJson(element));
      });
      return phaseContrators;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseChecklist(String id) async {
    dynamic json = await WebService()
        .get(phaseChecklistUrl.replaceFirst('all', 'one') + '?id=$id');

    try {
      return PhaseChecklistResponse.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseChecklistList(String id) async {
    dynamic json = await WebService().get(phaseChecklistUrl + '?phase_id=$id');

    try {
      return PhaseChecklistResponse.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createPhaseChecklist(
      PhaseChecklistRequest phaseChecklistRequest) async {
    dynamic json = await WebService().post(
      phaseChecklistUrl.replaceAll('all', 'create'),
      phaseChecklistRequest,
    );

    try {
      return PhaseChecklist.fromJson(json['phase_checklist']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deletePhaseChecklist(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      phaseChecklistUrl.replaceAll('all', 'delete'),
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseChecklistInfoList(String id) async {
    dynamic json = await WebService()
        .get(phaseChecklistInfoUrl + '?phase_checklist_id=$id');
    List<PhaseChecklistInfo> phaseChecklistInfos = [];

    try {
      json['checklist_informations'].forEach((element) {
        phaseChecklistInfos.add(PhaseChecklistInfo.fromJson(element));
      });
      return phaseChecklistInfos;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createPhaseChecklistInfo(
      PhaseChecklistInfoRequest phaseChecklistInfoRequest) async {
    dynamic json = await WebService().post(
      phaseChecklistInfoCreateUrl,
      phaseChecklistInfoRequest.toJson(),
    );

    try {
      return PhaseChecklistInfo.fromJson(json['checklist_information']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updatePhaseChecklistState(
      PhaseChecklistStateRequest phaseChecklistStateRequest) async {
    dynamic json = await WebService().patch(
      phaseChecklistStateUpdateUrl,
      phaseChecklistStateRequest.toJson(),
      null,
    );

    try {
      return PhaseChecklist.fromJson(json['phase_checklist']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> addPhaseChecklistInfoFile(
      PhaseChecklistInfoFileRequest phaseChecklistInfoFileRequest) async {
    dynamic json = await WebService().postFormData(phaseChecklistInfoFileUrl,
        await phaseChecklistInfoFileRequest.toFormData());

    if (json == null || json == '' || json == true) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseChecklistMessages({
    required Pagination pagination,
    required String id,
  }) async {
    dynamic json = await WebService().get(phaseChecklistMessagesUrl +
        '?limit=${pagination.size}&offset=${pagination.offset}&checklist_id=$id');

    try {
      return PhaseChecklistMessagesResponse.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createPhaseChecklistMessage(
      PhaseChecklistMessageRequest phaseChecklistMessageRequest) async {
    dynamic json = await WebService().post(
      phaseChecklistCreateMessageUrl,
      phaseChecklistMessageRequest.toJson(),
    );

    try {
      return PhaseChecklistMessage.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createPhaseContractor(
      PhaseContractorRequest phaseContractorRequest) async {
    dynamic json = await WebService().post(
      phaseContractorCreateUrl,
      phaseContractorRequest.toJson(),
    );

    try {
      return PhaseContractor.fromJson(json['phase_contractor']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updatePhaseContractor(
      PhaseContractorUpdateRequest phaseContractorUpdateRequest) async {
    dynamic json = await WebService().patch(
      phaseContractorUpdateUrl,
      phaseContractorUpdateRequest.toJson(),
      null,
    );

    try {
      return PhaseContractor.fromJson(json['phase_contractor']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deletePhaseContractor(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      phaseContractorDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createPhaseProduct(
      PhaseProductRequest phaseProductRequest) async {
    dynamic json = await WebService().post(
      phaseProductCreateUrl,
      phaseProductRequest.toJson(),
    );

    try {
      return PhaseProduct.fromJson(json['phase_product']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updatePhaseProduct(
      PhaseProductUpdateRequest phaseProductUpdateRequest) async {
    dynamic json = await WebService().patch(
      phaseProductUpdateUrl,
      phaseProductUpdateRequest.toJson(),
      null,
    );

    try {
      return PhaseProduct.fromJson(json['phase_product']);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deletePhaseProduct(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(
      phaseProductDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
