import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class ObjectFileRequest {
  final String taskId;
  final File file;

  ObjectFileRequest(this.taskId, this.file);

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "object_id": taskId,
      "file": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(
              file.path.length > 12
                  ? file.path.length - 10
                  : file.path.length - 6,
              file.path.length))
    });
  }
}
