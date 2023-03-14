import 'dart:convert';

DealProcessInfo dealProcessInfoFromJson(String str) =>
    DealProcessInfo.fromJson(json.decode(str));

class DealProcessInfo {
  DealProcessInfo({
    required this.createdAt,
    required this.dealStageProcessId,
    required this.description,
    required this.files,
    required this.id,
    required this.userId,
  });

  String createdAt;
  String dealStageProcessId;
  String description;
  List<DealProcessInfoFile> files;
  String id;
  String userId;

  factory DealProcessInfo.fromJson(Map<String, dynamic> json) =>
      DealProcessInfo(
        createdAt: json["created_at"],
        dealStageProcessId: json["deal_stage_process_id"],
        description: json["description"],
        files: List<DealProcessInfoFile>.from(
            json["files"].map((x) => DealProcessInfoFile.fromJson(x))),
        id: json["id"],
        userId: json["user_id"],
      );
}

class DealProcessInfoFile {
  DealProcessInfoFile({
    required this.dealStageProcessInformationId,
    required this.filename,
    required this.id,
    required this.mimetype,
    required this.name,
  });

  String dealStageProcessInformationId;
  String filename;
  String id;
  String mimetype;
  String name;

  factory DealProcessInfoFile.fromJson(Map<String, dynamic> json) =>
      DealProcessInfoFile(
        dealStageProcessInformationId:
            json["deal_stage_process_information_id"],
        filename: json["filename"],
        id: json["id"],
        mimetype: json["mimetype"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "deal_stage_process_information_id": dealStageProcessInformationId,
        "filename": filename,
        "id": id,
        "mimetype": mimetype,
        "name": name,
      };
}
