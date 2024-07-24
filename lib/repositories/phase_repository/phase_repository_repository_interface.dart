import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class PhaseRepositoryInterface {
  Future<dynamic> getPhases(String id);

  Future<dynamic> getPhase(String id);

  Future<dynamic> getPhaseProducts(String id);

  Future<dynamic> getPhaseDeals(String id);

  Future<dynamic> getPhaseContractors(String id);

  Future<dynamic> getPhaseChecklist(String id);

  Future<dynamic> getPhaseChecklistList(String id);

  Future<dynamic> createPhaseChecklist(
      PhaseChecklistRequest phaseChecklistRequest);

  Future<dynamic> deletePhaseChecklist(DeleteRequest deleteRequest);

  Future<dynamic> getPhaseChecklistInfoList(String id);

  Future<dynamic> createPhaseChecklistInfo(
      PhaseChecklistInfoRequest phaseChecklistInfoRequest);

  Future<dynamic> updatePhaseChecklistState(
      PhaseChecklistStateRequest phaseChecklistStateRequest);

  Future<dynamic> addPhaseChecklistInfoFile(
      PhaseChecklistInfoFileRequest phaseChecklistInfoFileRequest);

  Future<dynamic> getPhaseChecklistMessages({
    required Pagination pagination,
    required String id,
  });

  Future<dynamic> createPhaseChecklistMessage(
      PhaseChecklistMessageRequest phaseChecklistMessageRequest);

  Future<dynamic> createPhaseContractor(
      PhaseContractorRequest phaseContractorRequest);

  Future<dynamic> updatePhaseContractor(
      PhaseContractorUpdateRequest phaseContractorUpdateRequest);

  Future<dynamic> deletePhaseContractor(DeleteRequest deleteRequest);

  Future<dynamic> createPhaseProduct(PhaseProductRequest phaseProductRequest);

  Future<dynamic> updatePhaseProduct(
      PhaseProductUpdateRequest phaseProductUpdateRequest);

  Future<dynamic> deletePhaseProduct(DeleteRequest deleteRequest);
}
