import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/services/urls.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class PhaseChecklistCompleteViewModel with ChangeNotifier {
  final PhaseChecklistInfo? phaseChecklistInfo;

  final List<PlatformFile> _files = [];

  int _downloadIndex = -1;

  List<PlatformFile> get files {
    return _files;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  PhaseChecklistCompleteViewModel(this.phaseChecklistInfo);

  // MARK: -
  // MARK: - FUNCTIONS

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      for (var file in result.files) {
        _files.add(file);
      }
    }

    notifyListeners();
  }

  Future openFile(BuildContext context, int index) async {
    if (phaseChecklistInfo == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      String url = phaseChecklistInfoMediaUrl +
          phaseChecklistInfo!.files[index].filename;

      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName = phaseChecklistInfo!.files[index].name;
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          _downloadIndex = index;
          notifyListeners();

          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
            debugPrint('---Download----Rec: $count, Total: $total');
          }).then((value) => {_downloadIndex = -1, notifyListeners()});
        }

        OpenResult openResult = await OpenFilex.open(filePath);

        if (openResult.type == ResultType.noAppToOpen) {
          Toast().showTopToast(context, Titles.unsupportedFileFormat);
        }
      } else {
        if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
          launchUrl(Uri.parse(url.replaceAll(' ', '')));
        } else if (await canLaunchUrl(
            Uri.parse('https://' + url.replaceAll(' ', '')))) {
          launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
        }
      }
    }
  }

  void removeFile(int index) {
    _files.removeAt(index);
    notifyListeners();
  }
}
