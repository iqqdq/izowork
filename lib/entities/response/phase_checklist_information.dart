import 'dart:convert';

PhaseChecklistInformation phaseChecklistInformationFromJson(String str) =>
    PhaseChecklistInformation.fromJson(json.decode(str));

String phaseChecklistInformationToJson(PhaseChecklistInformation data) =>
    json.encode(data.toJson());

class PhaseChecklistInformation {
  PhaseChecklistInformation({
    this.createdAt,
    this.description,
    required this.files,
    required this.id,
    required this.phaseChecklistId,
    required this.userId,
  });

  String? createdAt;
  String? description;
  List<FileElement> files;
  String id;
  String phaseChecklistId;
  String userId;

  factory PhaseChecklistInformation.fromJson(Map<String, dynamic> json) =>
      PhaseChecklistInformation(
        createdAt: json["created_at"],
        description: json["description"],
        files: json["files"] == null
            ? []
            : List<FileElement>.from(
                json["files"].map((x) => FileElement.fromJson(x))),
        id: json["id"],
        phaseChecklistId: json["phase_checklist_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "description": description,
        "files": List<dynamic>.from(files.map((x) => x.toJson())),
        "id": id,
        "phase_checklist_id": phaseChecklistId,
        "user_id": userId,
      };
}

class FileElement {
  FileElement({
    required this.checklistInformationId,
    required this.filename,
    required this.id,
    required this.mimetype,
    required this.name,
  });

  String checklistInformationId;
  String filename;
  String id;
  String mimetype;
  String name;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        checklistInformationId: json["checklist_information_id"],
        filename: json["filename"],
        id: json["id"],
        mimetype: json["mimetype"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "checklist_information_id": checklistInformationId,
        "filename": filename,
        "id": id,
        "mimetype": mimetype,
        "name": name,
      };
}