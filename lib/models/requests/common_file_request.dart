import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class CommonFileRequest {
  final String officeId;
  final String? folderId;
  final bool isCommon;
  final File file;

  CommonFileRequest({
    required this.officeId,
    this.folderId,
    required this.isCommon,
    required this.file,
  });

  Future<FormData> toFormData() async {
    return folderId == null
        ? dio.FormData.fromMap({
            "office_id": officeId,
            "is_common": isCommon,
            "file": await MultipartFile.fromFile(file.path,
                filename: file.path.substring(
                    file.path.length > 12
                        ? file.path.length - 10
                        : file.path.length - 6,
                    file.path.length)),
          })
        : dio.FormData.fromMap({
            "office_id": officeId,
            "folder_id": folderId,
            "is_common": isCommon,
            "file": await MultipartFile.fromFile(file.path,
                filename: file.path.substring(
                    file.path.length > 12
                        ? file.path.length - 10
                        : file.path.length - 6,
                    file.path.length)),
          });
  }
}
