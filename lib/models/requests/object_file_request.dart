import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class ObjectFileRequest {
  final String objectId;
  final String? folderId;
  final File file;

  ObjectFileRequest({
    required this.objectId,
    this.folderId,
    required this.file,
  });

  Future<FormData> toFormData() async {
    return folderId == null
        ? dio.FormData.fromMap({
            "object_id": objectId,
            "file": await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            )
          })
        : dio.FormData.fromMap({
            "object_id": objectId,
            "folder_id": folderId,
            "file": await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            )
          });
  }
}
