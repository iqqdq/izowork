import 'dart:convert';

String phaseContractorRequestToJson(PhaseContractorRequest data) =>
    json.encode(data.toJson());

class PhaseContractorRequest {
  PhaseContractorRequest({
    this.coExecutorId,
    this.contractorId,
    this.observerId,
    required this.phaseId,
    this.responsibleId,
  });

  String? coExecutorId;
  String? contractorId;
  String? observerId;
  String phaseId;
  String? responsibleId;

  Map<String, dynamic> toJson() => {
        "co_executor_id": coExecutorId,
        "contractor_id": contractorId,
        "observer_id": observerId,
        "phase_id": phaseId,
        "responsible_id": responsibleId,
      };
}
