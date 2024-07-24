class PhaseContractorUpdateRequest {
  PhaseContractorUpdateRequest({
    required this.id,
    this.coExecutorId,
    this.contractorId,
    this.observerId,
    this.responsibleId,
  });

  String id;
  String? coExecutorId;
  String? contractorId;
  String? observerId;
  String? responsibleId;

  Map<String, dynamic> toJson() => {
        "co_executor_id": coExecutorId,
        "contractor_id": contractorId,
        "observer_id": observerId,
        "id": id,
        "responsible_id": responsibleId,
      };
}
