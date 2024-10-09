import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

class MessageFileRequest {
  final String chatId;
  final File file;
  final bool isVoice;

  MessageFileRequest(
    this.chatId,
    this.file,
    this.isVoice,
  );

  Future<FormData> toFormData() async {
    return dio.FormData.fromMap({
      "chat_id": chatId,
      "is_voice": isVoice,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      )
    });
  }
}
