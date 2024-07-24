// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

class PhaseChecklistViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final PhaseChecklist phaseChecklist;

  PhaseChecklistInfo? _phaseChecklistInfo;

  PhaseChecklistInfo? get phaseChecklistInfo => _phaseChecklistInfo;

  final List<PlatformFile> _files = [];

  List<PlatformFile> get files => _files;

  int _downloadIndex = -1;

  int get downloadIndex => _downloadIndex;

  PhaseChecklistViewModel(this.phaseChecklist) {
    getPhaseChecklistInfoList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseChecklistInfoList() async {
    await sl<PhaseRepositoryInterface>()
        .getPhaseChecklistInfoList(phaseChecklist.id)
        .then((response) => {
              if (response is List<PhaseChecklistInfo>)
                {
                  if (response.isNotEmpty) _phaseChecklistInfo = response.first,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future createPhaseChecklistInfo(String description) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    int current = 0;

    await sl<PhaseRepositoryInterface>()
        .createPhaseChecklistInfo(PhaseChecklistInfoRequest(
          phaseChecklistId: phaseChecklist.id,
          description: description,
        ))
        .then((response) => {
              if (response is PhaseChecklistInfo)
                {
                  _phaseChecklistInfo = response,
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        if (element.path == null) return;

                        await uploadFile(
                          response.id,
                          File(element.path!),
                        ).then((value) => {
                              current++,
                              if (current == _files.length)
                                loadingStatus = LoadingStatus.completed,
                            });
                      })
                    }
                  else
                    loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    String id,
    File file,
  ) async =>
      await sl<PhaseRepositoryInterface>()
          .addPhaseChecklistInfoFile(PhaseChecklistInfoFileRequest(id, file));

  // MARK: -
  // MARK: - FUNCTIONS

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      for (var file in result.files) {
        _files.add(file);
      }
    }

    notifyListeners();
  }

  Future openFile(int index) async {
    if (phaseChecklistInfo == null) {
      if ((await OpenFilex.open(_files[index].path)).type ==
          ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      final filename = phaseChecklistInfo!.files[index].filename;

      await sl<FileDownloadServiceInterface>().download(
          url: phaseChecklistInfoMediaUrl + filename,
          filename: filename,
          onDownload: () => {
                _downloadIndex = index,
                notifyListeners(),
              },
          onComplete: () => {
                _downloadIndex = -1,
                notifyListeners(),
              });
    }
  }

  void removeFile(int index) {
    _files.removeAt(index);
    notifyListeners();
  }
}
