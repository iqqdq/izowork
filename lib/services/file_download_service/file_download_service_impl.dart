import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/helpers/web_view_helper.dart';
import 'package:izowork/services/file_download_service/file_download_service_interface.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadServiceImpl implements FileDownloadServiceInterface {
  final Dio dio;

  FileDownloadServiceImpl({required this.dio});

  @override
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

        await Dio().download(url, filePath).whenComplete(() => onComplete());
      }

      if ((await OpenFilex.open(filePath)).type == ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      WebViewHelper().open(url);
    }
  }
}
