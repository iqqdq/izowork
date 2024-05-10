// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/screens/single_object_map/single_object_map_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/local_storage/local_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class ObjectPageViewModel with ChangeNotifier {
  final String objectId;

  final List<ObjectStage>? objectStages;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isDirector = false;

  MapObject? _object;

  List<Phase> _phases = [];

  int _downloadIndex = -1;

  bool get isDirector => _isDirector;

  MapObject? get object => _object;

  int get downloadIndex => _downloadIndex;

  List<Phase> get phases => _phases;

  ObjectPageViewModel(
    this.objectId,
    this.objectStages,
  ) {
    checkIsDirector().whenComplete(
        () => getObjectById(objectId).whenComplete(() => getPhaseList()));
  }

  Future checkIsDirector() async => _isDirector =
      (await GetIt.I<LocalStorageService>().getUser())?.state.toLowerCase() ==
              'director'
          ? true
          : false;

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

  Future getPhaseList() async {
    await PhaseRepository()
        .getPhases(objectId)
        .then((response) => {
              if (response is List<Phase>)
                {
                  _phases = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(BuildContext context, int index) async {
    String url = objectMediaUrl + (_object?.files[index].filename ?? '');

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = _object?.files[index].name ?? '';
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio()
            .download(url, filePath, onReceiveProgress: (count, total) {
              debugPrint('---Download----Rec: $count, Total: $total');
            })
            .then(
              (value) => _downloadIndex = -1,
            )
            .whenComplete(() => notifyListeners());
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
  // MARK: - PUSH

  void showObjectCreateSheet(
    BuildContext context,
    VoidCallback onUpdate,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectCreateScreenWidget(
                object: _object,
                onPop: (object) {
                  _object = object;
                  onUpdate();
                  notifyListeners();
                })));
  }

  void showObjectOnMap(BuildContext context) {
    if (_object != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SingleObjectMapScreenWidget(object: _object!)));
    }
  }

  void showObjectAnalyticsPageViewScreen(BuildContext context) {
    if (_object == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectAnalyticsScreenWidget(
                  object: _object!,
                  phases: _phases,
                )));
  }

  void showDocumentsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentsScreenWidget(id: objectId)));
  }

  Future showPhaseScreen(
    BuildContext context,
    int index,
  ) async {
    User? user = await GetIt.I<LocalStorageService>().getUser();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhaseScreenWidget(
                  user: user,
                  phase: _phases[index],
                  object: object,
                )));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DialogScreenWidget(
                  chat: object!.chat!,
                  onPop: (message) => null,
                )));
  }
}
