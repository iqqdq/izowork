import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class PhaseChecklistInfoFileRequest {
  final String id;
  final File file;

  PhaseChecklistInfoFileRequest(this.id, this.file);

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "checklist_information_id": id,
      "file": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(
              file.path.length > 12
                  ? file.path.length - 10
                  : file.path.length - 6,
              file.path.length))
    });
  }
}
