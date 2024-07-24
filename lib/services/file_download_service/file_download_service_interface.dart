import 'package:flutter/material.dart';

abstract class FileDownloadServiceInterface {
  Future download({
    required String url,
    required String filename,
    required VoidCallback onDownload,
    required VoidCallback onComplete,
  });
}
