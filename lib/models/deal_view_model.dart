// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/deal_create_request.dart';
import 'package:izowork/entities/request/deal_file_request.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/deal_process.dart';
import 'package:izowork/entities/response/deal_stage.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/screens/deal/close_deal_sheet.dart';
import 'package:izowork/screens/deal/complete_deal_sheet.dart';
import 'package:izowork/screens/deal/edit_deal_process_sheet.dart';
import 'package:izowork/screens/deal/process_action_sheet.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:izowork/services/urls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class DealViewModel with ChangeNotifier {
  final Deal selectedDeal;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Deal? _deal;

  List<DealProduct> _dealProducts = [];

  DealStage? _dealStage;

  List<Document> _documents = [];

  List<DealProcess> _dealProcesses = [];

  int _downloadIndex = -1;

  int current = 0;

  final List<int> _expanded = [];

  Deal? get deal {
    return _deal;
  }

  DealStage? get dealStage {
    return _dealStage;
  }

  List<DealProduct> get dealProducts {
    return _dealProducts;
  }

  List<Document> get documents {
    return _documents;
  }

  List<DealProcess> get dealProcesses {
    return _dealProcesses;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  List<int> get expanded {
    return _expanded;
  }

  DealViewModel(this.selectedDeal) {
    _deal = selectedDeal;
    _documents = selectedDeal.files;
    notifyListeners();

    getDealProducts();
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealById() async {
    await DealRepository().getDeal(selectedDeal.id).then((response) => {
          if (response is Deal)
            {
              _deal = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  Future getDealProducts() async {
    await DealRepository().getProduts(selectedDeal.id).then((response) => {
          if (response is List<DealProduct>)
            {
              _dealProducts = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  Future getDealProcesses() async {
    await DealRepository().getProcesses(selectedDeal.id).then((response) => {
          if (response is List<DealProcess>)
            {
              _dealProcesses = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  Future closeDeal(BuildContext context, String? comment) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .updateDeal(DealCreateRequest(
          closed: true,
          id: selectedDeal.id,
          comment: comment,
          companyId: selectedDeal.companyId,
          objectId: selectedDeal.objectId,
          responsibleId: selectedDeal.responsibleId,
          createdAt: selectedDeal.createdAt,
          finishAt: selectedDeal.finishAt,
        ))
        .then((response) => {
              if (response is Deal)
                {_deal = response}
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future uploadFile(BuildContext context, String id, File file) async {
    await DealRepository()
        .addDealFile(DealFileRequest(id, file))
        .then((response) => {
              if (response is Document)
                {_documents.add(response)}
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            });
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(BuildContext context, int index) async {
    String url = dealMediaUrl +
        (_deal?.files[index].filename ?? selectedDeal.files[index].filename);

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName =
          _deal?.files[index].name ?? selectedDeal.files[index].name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
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

  // MARK: -
  // MARK: - ACTIONS

  void expand(int index) {
    if (_expanded.contains(index)) {
      _expanded.removeWhere((element) => element == index);
    } else {
      _expanded.add(index);
    }

    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showDealCreateScreenSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealCreateScreenWidget(
                deal: selectedDeal,
                onCreate: (deal, dealProducts) => {
                      _deal = deal,
                      _dealProducts = dealProducts,
                      notifyListeners()
                    })));
  }

  void showSelectionScreenSheet(BuildContext context) {
    // showCupertinoModalBottomSheet(
    //     topRadius: const Radius.circular(16.0),
    //     barrierColor: Colors.black.withOpacity(0.6),
    //     backgroundColor: HexColors.white,
    //     context: context,
    //     builder: (context) => SelectionScreenWidget(
    //         selectionType: SelectionType.deal, onSelectTap: () => {}));
  }

  void showProcessActionScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ProcessActionSheet(
            title: 'Позиция',
            onTap: (index) => {
                  if (index == 0)
                    {
                      Future.delayed(const Duration(milliseconds: 200),
                          () => showEditDealProcessScreenSheet(context))
                    }
                }));
  }

  void showEditDealProcessScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            EditDealProcessSheetWidget(onTap: (text, files) => {}));
  }

  void showCloseDealScreenSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => CloseDealSheetWidget(
            onTap: (text, files) => {
                  Navigator.pop(context),
                  closeDeal(context, text).then((value) => {
                        if (files.isNotEmpty)
                          {
                            files.forEach((element) async {
                              await uploadFile(context, selectedDeal.id,
                                      File(element.path!))
                                  .then((value) => {
                                        current++,
                                        if (current == files.length)
                                          {
                                            loadingStatus =
                                                LoadingStatus.completed,
                                            notifyListeners(),
                                            Toast().showTopToast(context,
                                                '${Titles.deal} ${selectedDeal.number} успешно закрыта')
                                          }
                                      });
                            })
                          }
                        else
                          {
                            Toast().showTopToast(context,
                                '${Titles.deal} ${selectedDeal.number} успешно закрыта')
                          }
                      })
                }));
  }
}
