class TaskRequest {
  TaskRequest({
    this.id,
    this.coExecutorId,
    this.companyId,
    required this.deadline,
    this.description,
    required this.name,
    this.objectId,
    this.responsibleId,
    required this.state,
    this.taskManagerId,
  });

  String? id;
  String? coExecutorId;
  String? companyId;
  String deadline;
  String? description;
  String name;
  String? objectId;
  String? responsibleId;
  String state;
  String? taskManagerId;

  Map<String, dynamic> toJson() => {
        "id": id,
        "co_executor_id": coExecutorId,
        "company_id": companyId,
        "deadline": deadline,
        "description": description,
        "name": name,
        "object_id": objectId,
        "responsible_id": responsibleId,
        "state": state,
        "task_manager_id": taskManagerId,
      };
}
