import 'dart:convert';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/user.dart';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    required this.id,
    required this.number,
    required this.name,
    required this.state,
    required this.deadline,
    this.responsibleId,
    this.taskManagerId,
    this.coExecutorId,
    this.objectId,
    this.companyId,
    required this.description,
    required this.files,
    this.responsible,
    this.taskManager,
    this.coExecutor,
    this.object,
    this.company,
  });

  String id;
  int number;
  String name;
  String state;
  String deadline;
  String? responsibleId;
  String? taskManagerId;
  String? coExecutorId;
  String? objectId;
  String? companyId;
  String description;
  List<Document> files;
  User? responsible;
  User? taskManager;
  User? coExecutor;
  Object? object;
  Company? company;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        number: json["number"],
        name: json["name"],
        state: json["state"],
        deadline: json["deadline"],
        responsibleId: json["responsible_id"],
        taskManagerId: json["task_manager_id"],
        coExecutorId: json["co_executor_id"],
        objectId: json["object_id"],
        companyId: json["company_id"],
        description: json["description"] == null ? '' : json["description"],
        files: json["files"] == null
            ? []
            : List<Document>.from(
                json["files"].map((x) => Document.fromJson(x))),
        responsible: json["responsible"] == null
            ? null
            : User.fromJson(json["responsible"]),
        taskManager: json["task_manager"] == null
            ? null
            : User.fromJson(json["task_manager"]),
        coExecutor: json["co_executor"] == null
            ? null
            : User.fromJson(json["co_executor"]),
        object: json["object"] == null ? null : Object.fromJson(json["object"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "name": name,
        "state": state,
        "deadline": deadline,
        "responsible_id": responsibleId,
        "task_manager_id": taskManagerId,
        "co_executor_id": coExecutorId,
        "object_id": objectId,
        "company_id": companyId,
        "description": description,
        "files": List<Document>.from(files.map((x) => x)),
        "responsible": responsible?.toJson(),
        "task_manager": taskManager?.toJson(),
        "co_executor": coExecutor?.toJson(),
        "object": object?.toJson(),
        "company": company?.toJson(),
      };
}
