// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class DealViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Deal? _deal;

  List<DealProduct> _dealProducts = [];

  List<DealStage> _dealStages = [];

  List<Phase> _phases = [];

  Phase? _phase;

  int _downloadIndex = -1;

  final List<int> _expanded = [];

  Deal? get deal => _deal;

  List<DealProduct> get dealProducts => _dealProducts;

  List<DealStage> get dealStages => _dealStages;

  List<Phase> get phases => _phases;

  Phase? get phase => _phase;

  int get downloadIndex => _downloadIndex;

  List<int> get expanded => _expanded;

  DealViewModel(this.id) {
    getDealById();
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealById() async {
    await DealRepository()
        .getDeal(id)
        .then((response) => {
              if (response is Deal)
                _deal = response
              else
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                }
            })
        .whenComplete(() => getDealProducts());
  }

  Future getDealProducts() async {
    await DealRepository()
        .getProduts(id)
        .then((response) => {
              if (response is List<DealProduct>)
                _dealProducts = response
              else
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                }
            })
        .whenComplete(() => getPhaseList());
  }

  Future getPhaseList() async {
    if (_deal!.object != null) {
      await PhaseRepository()
          .getPhases(_deal!.object!.id)
          .then((response) => {
                if (response is List<Phase>)
                  {
                    _phases = response,
                    _phases.forEach((element) {
                      if (deal!.phaseId == element.id) {
                        _phase = element;
                      }
                    }),
                  }
              })
          .whenComplete(() => getDealStageList());
    } else {
      getDealStageList();
    }
  }

  Future getDealStageList() async {
    await DealRepository()
        .getStage(deal!.id)
        .then((response) => {
              if (response is List<DealStage>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _dealStages = response,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => getDealProcesses());
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
                    element.processes = response
                  else
                    loadingStatus = LoadingStatus.error,
                })
            .whenComplete(() => {
                  loadingStatus = LoadingStatus.completed,
                  notifyListeners(),
                });
      });
    }
  }

  Future uploadFiles(
    String id,
    List<File> files,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    for (var element in files) {
      await DealRepository()
          .addDealFile(DealFileRequest(
            id,
            element,
          ))
          .then((response) => {
                if (response is Document)
                  {
                    _deal?.files.add(response),
                    loadingStatus = LoadingStatus.completed,
                  }
                else if (response is ErrorResponse)
                  {
                    loadingStatus = LoadingStatus.error,
                    Toast().showTopToast(response.message ?? 'Произошла ошибка')
                  }
              });
    }

    notifyListeners();
  }

  Future closeDeal(String? comment) async {
    if (_deal == null) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .updateDeal(DealRequest(
          closed: true,
          id: id,
          comment: comment,
          companyId: _deal!.companyId,
          objectId: _deal!.objectId,
          responsibleId: _deal!.responsibleId,
          createdAt: _deal!.createdAt,
          finishAt: _deal!.finishAt,
        ))
        .then((response) => {
              if (response is Deal)
                _deal = response
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateDealProcess(
    bool hidden,
    String id,
    String status,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
        .updateProcess(DealProcessUpdateRequest(
          hidden: hidden,
          id: id,
          status: status,
        ))
        .then((response) => {
              if (response is DealProcess)
                loadingStatus = LoadingStatus.completed
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .whenComplete(() => getDealProcesses());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void updateDeal(
    Deal? deal,
    List<DealProduct> dealProducts,
  ) {
    _deal = deal;
    _dealProducts = dealProducts;

    Future.delayed(const Duration(milliseconds: 300), () => notifyListeners());
  }

  Future openFile(int index) async {
    if (_deal!.files[index].filename == null) return;
    final filename = _deal!.files[index].filename!;

    FileDownloadHelper().download(
        url: dealMediaUrl + filename,
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

  void expand(int index) {
    _expanded.contains(index) ? _expanded.remove(index) : _expanded.add(index);
    notifyListeners();
  }
}
