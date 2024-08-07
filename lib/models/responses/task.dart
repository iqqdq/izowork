import 'package:izowork/models/models.dart';

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
  DateTime deadline;
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
  MapObject? object;
  Company? company;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        number: json["number"],
        name: json["name"],
        state: json["state"],
        deadline: DateTime.parse(json["deadline"]).toUtc().toLocal(),
        responsibleId: json["responsible_id"],
        taskManagerId: json["task_manager_id"],
        coExecutorId: json["co_executor_id"],
        objectId: json["object_id"],
        companyId: json["company_id"],
        description: json["description"] ?? '',
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
        object:
            json["object"] == null ? null : MapObject.fromJson(json["object"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );
}
