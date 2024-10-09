// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

class DealProcessViewModel with ChangeNotifier {
  final DealProcess dealProcess;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  List<DealProcessInfo> _informations = [];

  List<DealProcessInfo> get informations => _informations;

  DealProcessInfo? _information;

  DealProcessInfo? get information => _information;

  int _downloadIndex = -1;

  int get downloadIndex => _downloadIndex;

  DealProcessViewModel(this.dealProcess) {
    getDealProcessInformation(dealProcess.id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealProcessInformation(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .getProcessInformation(id)
        .then((response) => {
              if (response is List<DealProcessInfo>)
                {
                  _informations = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error
            })
        .then((value) => notifyListeners());
  }

  Future createDealProcessInformation(
    String dealStageProcessId,
    String description,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .createProcessInfo(DealProcessInfoRequest(
          dealStageProcessId: dealStageProcessId,
          description: description,
        ))
        .then((response) => {
              if (response is DealProcessInfo)
                {
                  _information = response,
                  _informations.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // Future updateDealProcessInformation(
  //     BuildContext context, String id, String description) async {
  //   loadingStatus = LoadingStatus.searching;
  //   notifyListeners();

  //   await sl<DealRepositoryInterface>()
  //       .updateProcessInfo(
  //           DealProcessInfoRequest(id: id, description: description))
  //       .then((response) => {
  //             if (response is DealProcessInfo)
  //               {
  //                 loadingStatus = LoadingStatus.completed,
  //                 Toast().showTopToast( Titles.infoWasUpdated),
  //                 Future.delayed(const Duration(milliseconds: 50),
  //                     () => Navigator.pop(context))
  //               }
  //             else if (response is ErrorResponse)
  //               {
  //                 loadingStatus = LoadingStatus.error,
  //                 Toast().showTopToast( response.message ?? 'Произошла ошибка')
  //               }
  //           })
  //       .whenComplete(() => notifyListeners());
  // }

  Future uploadDealProccessInfoFiles(
    String id,
    List<PlatformFile> files,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    int current = 0;

    files.forEach((element) async {
      if (element.path == null) return;

      File file = File(element.path!);
      FormData formData = dio.FormData.fromMap({
        "deal_stage_process_information_id": id,
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        )
      });

      await sl<DealRepositoryInterface>()
          .uploadProcessInfoFile(formData)
          .then((response) => {
                if (response is ErrorResponse)
                  {
                    Toast()
                        .showTopToast(response.message ?? 'Произошла ошибка'),
                    loadingStatus = LoadingStatus.error,
                    notifyListeners(),
                  },
              })
          .whenComplete(() {
        current++;
        if (current == files.length) {
          Toast().showTopToast(Titles.infoWasAdded);
          loadingStatus = LoadingStatus.completed;
          notifyListeners();
        }
      });
    });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future openFile(
    int index,
    int fileIndex,
  ) async {
    if (_informations[index].files.isEmpty) return;
    final filename = _informations[index].files[fileIndex].filename;

    sl<FileDownloadServiceInterface>().download(
        url: dealProcessInfoMediaUrl + filename,
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

  // MARK: -
  // MARK: - PUSH

  // void showDealProcessEditSheet(BuildContext context, DealProcess process) {
  // getDealProcessInformation(process.id).then((value) => {
  //        showCupertinoModalBottomSheet(
  // enableDrag: false,
  //           topRadius: const Radius.circular(16.0),
  //           barrierColor: Colors.black.withValues(alpha:0.6),
  //           backgroundColor: HexColors.white,
  //           context: context,
  //           builder: (context) => DealProcessCompleteSheetWidget(
  //               dealProcessInfo: _dealProcessInfo,
  //               title: process.name,
  //               onTap: (text, files) => {
  //                     if (_dealProcessInfo != null)
  //                       {
  //                         if (_dealProcessInfo!.description != text)
  //                           {
  //                             // UPDATE PROCESS DESCRIPTION
  //                             updateDealProcessInformation(
  //                                     context, _dealProcessInfo!.id, text)
  //                                 .then((value) => {
  //                                       if (files.isNotEmpty)
  //                                         {
  //                                           files.forEach((element) async {
  //                                             await uploadDealProccessInfoFile(
  //                                                     context,
  //                                                     _dealProcessInfo!.id,
  //                                                     File(element.path!))
  //                                                 .then((value) => {
  //                                                       current++,
  //                                                       if (current ==
  //                                                           files.length)
  //                                                         {
  //                                                           loadingStatus =
  //                                                               LoadingStatus
  //                                                                   .completed,
  //                                                           notifyListeners()
  //                                                         }
  //                                                     });
  //                                           })
  //                                         }
  //                                     })
  //                           }
  //                       }
  //                   }))
  //     });
  // }
}
