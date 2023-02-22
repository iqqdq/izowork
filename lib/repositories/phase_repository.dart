import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class PhaseRepository {
  Future<dynamic> getPhases(String id) async {
    dynamic json = await WebService().get(phaseUrl + '?object_id=$id');
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

  Future<dynamic> getPhaseChecklists(String id) async {
    dynamic json = await WebService().get(phaseChecklistUrl + '?phase_id=$id');
    List<PhaseChecklist> phaseChecklists = [];

    try {
      json['phase_checklists'].forEach((element) {
        phaseChecklists.add(PhaseChecklist.fromJson(element));
      });
      return phaseChecklists;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getPhaseChecklistInformations(String id) async {
    dynamic json = await WebService()
        .get(phaseChecklistInformationUrl + '?phase_checklist_id=$id');
    List<PhaseChecklistInformation> phaseChecklistInformations = [];

    try {
      json['checklist_informations'].forEach((element) {
        phaseChecklistInformations
            .add(PhaseChecklistInformation.fromJson(element));
      });
      return phaseChecklistInformations;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
