import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class TaskRepositoryInterface {
  Future<dynamic> getTask(String id);

  Future<dynamic> getTasks({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getYearTasks({required List<String> params});

  Future<dynamic> getTaskStates();

  Future<dynamic> createTask(TaskRequest taskRequest);

  Future<dynamic> updateTask(TaskRequest taskRequest);

  Future<dynamic> addTaskFile(TaskFileRequest taskFileRequest);

  Future<dynamic> deleteTaskFile(DeleteRequest deleteRequest);
}
