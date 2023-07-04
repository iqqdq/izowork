import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class MessageFileRequest {
  final String chatId;
  final File file;

  MessageFileRequest(
    this.chatId,
    this.file,
  );

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "chat_id": chatId,
      "is_voice": true,
      "file": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(
              file.path.length > 12
                  ? file.path.length - 10
                  : file.path.length - 6,
              file.path.length))
    });
  }
}
