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
import 'package:izowork/entities/request/deal_process_update_request.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/deal_process.dart';
import 'package:izowork/entities/response/deal_stage.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/deal/sheets/deal_close_sheet.dart';
import 'package:izowork/screens/deal/sheets/deal_process_action_sheet.dart';
import 'package:izowork/screens/deal/sheets/deal_process_complete_sheet.dart';
import 'package:izowork/screens/deal/sheets/deal_process_edit_sheet.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
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

  List<Document> _documents = [];

  List<DealStage> _dealStages = [];

  List<Phase> _phases = [];

  Phase? _phase;

  int _downloadIndex = -1;

  int current = 0;

  final List<int> _expanded = [];

  Deal? get deal {
    return _deal;
  }

  List<DealProduct> get dealProducts {
    return _dealProducts;
  }

  List<Document> get documents {
    return _documents;
  }

  List<DealStage> get dealStages {
    return _dealStages;
  }

  List<Phase> get phases {
    return _phases;
  }

  Phase? get phase {
    return _phase;
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

    getDealProducts().then((value) => getPhaseList().then(
        (value) => getDealStageList().then((value) => getDealProcesses())));
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
            {loadingStatus = LoadingStatus.error}
        });
  }

  Future getDealProducts() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository().getProduts(selectedDeal.id).then((response) => {
          if (response is List<DealProduct>)
            {
              _dealProducts = response,
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error}
        });
  }

  Future getPhaseList() async {
    if (deal!.object != null) {
      await PhaseRepository().getPhases(deal!.object!.id).then((response) => {
            if (response is List<Phase>)
              {
                _phases = response,
                _phases.forEach((element) {
                  if (deal!.phaseId == element.id) {
                    _phase = element;
                  }
                }),
                loadingStatus = LoadingStatus.completed,
              }
          });
    }
  }

  Future getDealStageList() async {
    await DealRepository().getStage(deal!.id).then((response) => {
          if (response is List<DealStage>)
            {loadingStatus = LoadingStatus.completed, _dealStages = response}
          else if (response is ErrorResponse)
            {loadingStatus = LoadingStatus.error}
        });
  }

  Future getDealProcesses() async {
    if (_dealStages.isNotEmpty) {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      _dealStages.forEach((element) async {
        await DealRepository()
            .getProcesses(element.id)
            .then((response) => {
                  if (response is List<DealProcess>)
                    {
                      element.processes = response,
                      loadingStatus = LoadingStatus.completed,
                    }
                  else
                    {loadingStatus = LoadingStatus.error}
                })
            .then((value) =>
                {loadingStatus = LoadingStatus.completed, notifyListeners()});
      });
    }
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

  Future updateDealProcess(
      BuildContext context, bool hidden, String id, String status) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .updateProcess(
            DealProcessUpdateRequest(hidden: hidden, id: id, status: status))
        .then((response) => {
              if (response is DealProcess)
                {
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .then((value) => notifyListeners());
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

  void expand(int index) {
    _expanded.contains(index) ? _expanded.remove(index) : _expanded.add(index);

    notifyListeners();
  }

  // MARK: -
  // MARK: - PUSH

  void showDealCreateSheet(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealCreateScreenWidget(
                deal: selectedDeal,
                phase: _phase,
                onCreate: (deal, dealProducts) => {
                      _deal = deal,
                      _dealProducts = dealProducts,
                      notifyListeners()
                    })));
  }

  void showSelectionSheet(BuildContext context, int index) {
    List<String> items = [];

    if (_dealStages[index].processes!.isNotEmpty) {
      _dealStages[index].processes?.forEach((element) {
        if (element.hidden) {
          items.add(element.name);
        }
      });

      showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.addProcess,
              items: items,
              onSelectTap: (value) => {
                    _dealStages[index].processes?.forEach((element) {
                      if (element.name == value) {
                        updateDealProcess(
                                context, false, element.id, element.status)
                            .then((value) =>
                                {element.hidden = false, notifyListeners()});
                      }
                    })
                  }));
    }
  }

  void showDealProcessActionSheet(BuildContext context, DealProcess process) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealProcessActionSheet(
            title: process.name,
            onTap: (index) => {
                  if (index == 0) // EDIT PROCESS
                    {
                      Future.delayed(const Duration(milliseconds: 200),
                          () => showDealProcessEditSheet(context, process))
                    }
                  else if (index == 1) // STOP PROCESS
                    {}
                  else if (index == 2) // DELETE PROCESS
                    {
                      updateDealProcess(
                              context, true, process.id, process.status)
                          .then((value) =>
                              {process.hidden = true, notifyListeners()})
                    }
                }));
  }

  void showDealProcessEditSheet(BuildContext context, DealProcess process) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) =>
            DealProcessEditSheetWidget(onTap: (text, files) => {}));
  }

  void showDealProcessCompleteSheet(BuildContext context, DealProcess process) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealProcessCompleteSheetWidget(
            title: process.name, onTap: (text, files) => {}));
  }

  void showDealCloseSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealCloseSheetWidget(
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
