import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'task_repository_interface.dart';

class TaskRepositoryImpl implements TaskRepositoryInterface {
  @override
  Future<dynamic> getTask(String id) async {
    dynamic json = await sl<WebServiceInterface>().get(taskUrl + id);

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getTasks(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        tasksUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Task> tasks = [];

    try {
      json['tasks'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getYearTasks({required List<String> params}) async {
    var url = tasksUrl + '?';

    for (var element in params) {
      url += element;
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Task> tasks = [];

    try {
      json['tasks'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getTaskStates() async {
    dynamic json = await sl<WebServiceInterface>().get(taskStatesUrl);

    try {
      return TaskState.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createTask(TaskRequest taskRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      taskCreateUrl,
      taskRequest.toJson(),
    );

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateTask(TaskRequest taskRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      taskUpdateUrl,
      taskRequest.toJson(),
      null,
    );

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> addTaskFile(TaskFileRequest taskFileRequest) async {
    dynamic json = await sl<WebServiceInterface>()
        .postFormData(taskFileUrl, await taskFileRequest.toFormData());

    try {
      return Document.fromJson(json["task_file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteTaskFile(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      taskFileUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
