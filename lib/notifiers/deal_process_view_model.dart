// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/deal/sheets/deal_process_info_sheet.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/api/api.dart';

class DealProcessViewModel with ChangeNotifier {
  final DealProcess dealProcess;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  List<DealProcessInfo> _informations = [];

  DealProcessInfo? _information;

  int _downloadIndex = -1;

  int current = 0;

  List<DealProcessInfo> get informations => _informations;

  DealProcessInfo? get information => _information;

  int get downloadIndex => _downloadIndex;

  DealProcessViewModel(this.dealProcess) {
    getDealProcessInformation(dealProcess.id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealProcessInformation(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .getProcessInformation(id)
        .then((response) => {
              if (response is List<DealProcessInfo>)
                {
                  _informations = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else
                {loadingStatus = LoadingStatus.error}
            })
        .then(
          (value) => notifyListeners(),
        );
  }

  Future createDealProcessInformation(BuildContext context,
      String dealStageProcessId, String description) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .createProcessInfo(DealProcessInfoRequest(
            dealStageProcessId: dealStageProcessId, description: description))
        .then((response) => {
              if (response is DealProcessInfo)
                {
                  _information = response,
                  _informations.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                  notifyListeners()
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // Future updateDealProcessInformation(
  //     BuildContext context, String id, String description) async {
  //   loadingStatus = LoadingStatus.searching;
  //   notifyListeners();

  //   await DealRepository()
  //       .updateProcessInfo(
  //           DealProcessInfoRequest(id: id, description: description))
  //       .then((response) => {
  //             if (response is DealProcessInfo)
  //               {
  //                 loadingStatus = LoadingStatus.completed,
  //                 Toast().showTopToast(context, Titles.infoWasUpdated),
  //                 Future.delayed(const Duration(milliseconds: 50),
  //                     () => Navigator.pop(context))
  //               }
  //             else if (response is ErrorResponse)
  //               {
  //                 loadingStatus = LoadingStatus.error,
  //                 Toast().showTopToast(context, response.message ?? 'Ошибка')
  //               }
  //           })
  //       .whenComplete(() => notifyListeners());
  // }

  Future uploadDealProccessInfoFile(
      BuildContext context, String id, File file) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    FormData formData = dio.FormData.fromMap({
      "deal_stage_process_information_id": id,
      "file": await MultipartFile.fromFile(file.path,
          filename: file.path.substring(file.path.length - 8, file.path.length))
    });

    await DealRepository().uploadProcessInfoFile(formData).then((response) => {
          if (response is String)
            {loadingStatus = LoadingStatus.completed}
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              Toast().showTopToast(context, response.message ?? 'Ошибка')
            },
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(BuildContext context, int index, int fileIndex) async {
    if (_informations[index].files.isNotEmpty) {
      String url = dealProcessInfoMediaUrl +
          _informations[index].files[fileIndex].filename;

      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName = _informations[index].files[fileIndex].name;
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          _downloadIndex = index;
          notifyListeners();

          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
            debugPrint('---Download----Rec: $count, Total: $total');
          }).then((value) => {
                _downloadIndex = -1,
                notifyListeners(),
              });
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

  // MARK: -
  // MARK: - PUSH

  void showDealProcessInfoSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DealProcessInfoSheetWidget(
            onTap: (text, files) => {
                  // CREATE PROCESS DESCRIPTION
                  createDealProcessInformation(context, dealProcess.id, text)
                      .then((value) => {
                            if (_information != null)
                              {
                                if (files.isNotEmpty)
                                  {
                                    files.forEach((element) async {
                                      if (element.path != null) {
                                        await uploadDealProccessInfoFile(
                                                context,
                                                _information!.id,
                                                File(element.path!))
                                            .then((value) => {
                                                  current++,
                                                  if (current == files.length)
                                                    {
                                                      loadingStatus =
                                                          LoadingStatus
                                                              .completed,
                                                      Toast().showTopToast(
                                                          context,
                                                          Titles.infoWasAdded),
                                                      notifyListeners()
                                                    }
                                                });
                                      }
                                    })
                                  }
                                else
                                  {
                                    loadingStatus = LoadingStatus.completed,
                                    Toast().showTopToast(
                                        context, Titles.infoWasAdded),
                                    notifyListeners()
                                  }
                              }
                          })
                }));
  }

  void showProfileScreen(BuildContext context, int index) {
    if (_informations[index].user != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreenWidget(
                    isMine: false,
                    user: _informations[index].user!,
                    onPop: (user) => null,
                  )));
    }
  }

  // void showDealProcessEditSheet(BuildContext context, DealProcess process) {
  // getDealProcessInformation(process.id).then((value) => {
  //        showCupertinoModalBottomSheet(
  // enableDrag: false,
  //           topRadius: const Radius.circular(16.0),
  //           barrierColor: Colors.black.withOpacity(0.6),
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
