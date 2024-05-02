// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/object_stage_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/screens/single_object_map/single_object_map_screen.dart';
import 'package:izowork/api/urls.dart';
import 'package:izowork/services/local_storage/local_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class ObjectPageViewModel with ChangeNotifier {
  final String objectId;

  final List<ObjectStage>? objectStages;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isAdmin = false;

  Object? _object;

  List<Phase> _phases = [];

  int _downloadIndex = -1;

  bool get isAdmin => _isAdmin;

  Object? get object => _object;

  int get downloadIndex => _downloadIndex;

  List<Phase> get phases => _phases;

  ObjectPageViewModel(
    this.objectId,
    this.objectStages,
  ) {
    checkIsAdmin().whenComplete(
        () => getObjectById(objectId).whenComplete(() => getPhaseList()));
  }

  Future checkIsAdmin() async => _isAdmin =
      (await GetIt.I<LocalStorageService>().getUser())?.state == 'ADMIN'
          ? true
          : false;

  // MARK: -
  // MARK: - API CALL

  Future getObjectById(String id) async {
    await ObjectRepository()
        .getObject(id)
        .then((response) => {
              if (response is Object)
                _object = response
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future changeObjectStage() async {
    if (object == null) return;

    ObjectStage? objectStage = _isAdmin
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

  Future copyCoordinates(
    BuildContext context,
    double lat,
    double long,
  ) async {
    Clipboard.setData(ClipboardData(text: '$lat, $long'));
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

  void showSingleObjectMap(BuildContext context) {
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
