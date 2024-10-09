import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class TaskFileRequest {
  final String taskId;
  final File file;

  TaskFileRequest(this.taskId, this.file);

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "task_id": taskId,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      )
    });
  }
}
