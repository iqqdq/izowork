import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class DealFileRequest {
  final String taskId;
  final File file;

  DealFileRequest(this.taskId, this.file);

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "deal_id": taskId,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      )
    });
  }
}
