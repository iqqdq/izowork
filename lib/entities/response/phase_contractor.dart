import 'dart:convert';

import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/user.dart';

PhaseContractor phaseContractorFromJson(String str) =>
    PhaseContractor.fromJson(json.decode(str));

String phaseContractorToJson(PhaseContractor data) =>
    json.encode(data.toJson());

class PhaseContractor {
  PhaseContractor(
      {this.coExecutorId,
      this.contractorId,
      required this.id,
      this.observerId,
      this.phaseId,
      this.responsibleId,
      this.contractor,
      this.coExecutor,
      this.responsible,
      this.observer});

  String? coExecutorId;
  String? contractorId;
  String id;
  String? observerId;
  String? phaseId;
  String? responsibleId;
  Company? contractor;
  User? coExecutor;
  User? responsible;
  User? observer;

  factory PhaseContractor.fromJson(Map<String, dynamic> json) =>
      PhaseContractor(
        coExecutorId: json["co_executor_id"],
        contractorId: json["contractor_id"],
        id: json["id"],
        observerId: json["observer_id"],
        phaseId: json["phase_id"],
        responsibleId: json["responsible_id"],
        contractor: json["contractor"] == null
            ? null
            : Company.fromJson(json["contractor"]),
        coExecutor: json["co_executor"] == null
            ? null
            : User.fromJson(json["co_executor"]),
        responsible: json["responsible"] == null
            ? null
            : User.fromJson(json["responsible"]),
        observer:
            json["observer"] == null ? null : User.fromJson(json["observer"]),
      );

  Map<String, dynamic> toJson() => {
        "co_executor_id": coExecutorId,
        "contractor_id": contractorId,
        "id": id,
        "observer_id": observerId,
        "phase_id": phaseId,
        "responsible_id": responsibleId,
        "contractor": contractor,
        "coExecutor": coExecutor,
        "responsible": responsible,
        "observer": observer,
      };
}
