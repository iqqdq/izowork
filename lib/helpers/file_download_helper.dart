import 'dart:io';
import 'dart:io' as io;
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/helpers/web_view_helper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadHelper {
  final Dio _dio = Dio();

  FileDownloadHelper() {
    _dio.interceptors.add(CurlLoggerDioInterceptor());
  }

  Future download({
    required String url,
    required String filename,
    required VoidCallback onDownload,
    required VoidCallback onComplete,
  }) async {
    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String filePath = '$appDocumentsPath/$filename';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        onDownload();

        await _dio.download(url, filePath).whenComplete(() => onComplete());
      }

      if ((await OpenFilex.open(filePath)).type == ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      WebViewHelper().open(url);
    }
  }
}
