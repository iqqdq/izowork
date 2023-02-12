import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    required this.id,
    required this.number,
    required this.name,
    required this.state,
    required this.deadline,
    required this.responsibleId,
    required this.taskManagerId,
    required this.coExecutorId,
    required this.objectId,
    required this.companyId,
    required this.description,
    required this.files,
  });

  String id;
  int number;
  String name;
  String state;
  DateTime deadline;
  String responsibleId;
  String taskManagerId;
  String coExecutorId;
  String objectId;
  String companyId;
  String description;
  List<dynamic> files;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        number: json["number"],
        name: json["name"],
        state: json["state"],
        deadline: DateTime.parse(json["deadline"]),
        responsibleId: json["responsible_id"],
        taskManagerId: json["task_manager_id"],
        coExecutorId: json["co_executor_id"],
        objectId: json["object_id"],
        companyId: json["company_id"],
        description: json["description"],
        files: List<dynamic>.from(json["files"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "name": name,
        "state": state,
        "deadline": deadline.toIso8601String(),
        "responsible_id": responsibleId,
        "task_manager_id": taskManagerId,
        "co_executor_id": coExecutorId,
        "object_id": objectId,
        "company_id": companyId,
        "description": description,
        "files": List<dynamic>.from(files.map((x) => x)),
      };
}
