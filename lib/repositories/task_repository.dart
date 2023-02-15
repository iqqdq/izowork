import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/task_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/entities/response/task_state.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class TaskRepository {
  Future<dynamic> getTask(String id) async {
    dynamic json = await WebService().get(taskUrl + id);

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }

  Future<dynamic> getTasks(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        tasksUrl + '?&offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Task> tasks = [];

    try {
      json['tasks'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }

  Future<dynamic> getTaskStates() async {
    dynamic json = await WebService().get(taskStatesUrl);

    try {
      return TaskState.fromJson(json);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }

  Future<dynamic> createTask(TaskRequest taskRequest) async {
    dynamic json = await WebService().post(taskCreateUrl, taskRequest);

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }

  Future<dynamic> updateTask(TaskRequest taskRequest) async {
    dynamic json = await WebService().patch(taskUpdateUrl, taskRequest);

    try {
      return Task.fromJson(json["task"]);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }
}
