// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class ObjectPageViewModel with ChangeNotifier {
  final String objectId;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isDirector = false;

  MapObject? _object;

  List<ObjectStage>? _objectStages;

  List<Phase> _phases = [];

  int _downloadIndex = -1;

  bool get isDirector => _isDirector;

  MapObject? get object => _object;

  List<ObjectStage>? get objectStages => _objectStages;

  int get downloadIndex => _downloadIndex;

  List<Phase> get phases => _phases;

  ObjectPageViewModel(this.objectId) {
    _checkIsDirector().whenComplete(() => getObjectById(objectId));
  }

  Future _checkIsDirector() async {
    User? user = await GetIt.I<LocalStorageRepositoryInterface>().getUser();
    if (user == null) return;
    if (user.roles == null) return;

    for (var role in user.roles!) {
      if (role.name.toLowerCase().contains('директор')) _isDirector = true;
      if (_isDirector) break;
    }
  }

  // MARK: -
  // MARK: - API CALL

  Future getObjectById(String id) async {
    await ObjectRepository()
        .getObject(id)
        .then((response) => {
              if (response is MapObject)
                _object = response
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => getObjectStageList());
  }

  Future getObjectStageList() async {
    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>)
                _objectStages = response
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => getPhaseList());
  }

  Future getPhaseList() async {
    if (loadingStatus == LoadingStatus.completed) {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await PhaseRepository()
        .getPhases(objectId)
        .then((response) => {
              if (response is List<Phase>)
                {
                  _phases = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future changeObjectStage() async {
    if (object == null) return;

    ObjectStage? objectStage = _isDirector
        ? objectStages?.firstWhere((element) => element.name == 'На доработке')
        : objectStages?.firstWhere(
            (element) => element.name == 'На рассмотрении руководителя');

    if (objectStage == null) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .changeObjectStage(ObjectStageRequest(
          id: object!.id,
          objectStageId: objectStage.id,
        ))
        .then((response) => {
              if (response is ObjectStage)
                {
                  loadingStatus = LoadingStatus.completed,
                  _object?.objectStage = objectStage,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future completeObject() async {
    if (object == null) return;

    ObjectStage? objectStage =
        objectStages?.firstWhere((element) => element.name == 'Закончен');

    if (objectStage == null) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .changeObjectStage(ObjectStageRequest(
          id: object!.id,
          objectStageId: objectStage.id,
        ))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  _object?.objectStage = objectStage,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future openFile(int index) async {
    final filename = _object?.files[index].filename;
    if (filename == null) return;

    FileDownloadHelper().download(
        url: objectMediaUrl + filename,
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
  // MARK: - FUNCTIONS

  void updateObject(MapObject? object) {
    _object = object;

    Future.delayed(const Duration(milliseconds: 300), () => notifyListeners());
  }
}
