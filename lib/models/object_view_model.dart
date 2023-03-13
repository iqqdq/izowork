// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/entities/response/object_type.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
import 'package:izowork/screens/object_analytics/object_analytics_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' as io;

class ObjectPageViewModel with ChangeNotifier {
  final Object selectedObject;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Object? _object;

  ObjectStage? _objectStage;

  List<ObjectStage> _objectStages = [];

  ObjectType? _objectType;

  List<ObjectType> _objectTypes = [];

  List<Phase> _phases = [];

  int _downloadIndex = -1;

  Object? get object {
    return _object;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  List<ObjectType> get objectTypes {
    return _objectTypes;
  }

  ObjectType? get objectType {
    return _objectType;
  }

  ObjectStage? get objectStage {
    return _objectStage;
  }

  List<ObjectStage> get objectStages {
    return _objectStages;
  }

  List<Phase> get phases {
    return _phases;
  }

  ObjectPageViewModel(this.selectedObject) {
    _object = selectedObject;
    notifyListeners();

    getTypeList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getTypeList() async {
    await ObjectRepository()
        .getObjectTypes()
        .then((response) => {
              if (response is List<ObjectType>)
                {
                  _objectTypes = response,
                  _objectTypes.forEach((element) {
                    if (_object?.objectTypeId == element.id) {
                      _objectType = element;
                      return;
                    }
                  })
                }
            })
        .then((value) => getStageList());
  }

  Future getStageList() async {
    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _objectStages = response,
                  _objectStages.forEach((element) {
                    if (_object?.objectStageId == element.id) {
                      _objectStage = element;
                      return;
                    }
                  })
                }
            })
        .then((value) => {notifyListeners(), getPhaseList()});
  }

  Future getPhaseList() async {
    await PhaseRepository()
        .getPhases(selectedObject.id)
        .then((response) => {
              if (response is List<Phase>)
                {
                  _phases = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .then((value) => notifyListeners());
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(BuildContext context, int index) async {
    String url = objectMediaUrl +
        (_object?.files[index].filename ??
            selectedObject.files[index].filename);

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName =
          _object?.files[index].name ?? selectedObject.files[index].name;
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

  Future copyCoordinates(BuildContext context, double lat, double long) async {
    Clipboard.setData(ClipboardData(text: '$lat, $long'));
  }

  // MARK: -
  // MARK: - PUSH

  void showObjectCreateSheet(BuildContext context, VoidCallback onUpdate) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectCreateScreenWidget(
                object: _object,
                onCreate: (object) {
                  _object = object;
                  onUpdate();
                  notifyListeners();
                })));
  }

  void showDialogScreen(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DialogScreenWidget()));
  }

  void showObjectAnalyticsPageViewScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ObjectAnalyticsScreenWidget()));
  }

  void showDocumentsScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DocumentsScreenWidget(id: selectedObject.id)));
  }

  void showPhaseScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PhaseScreenWidget(phase: _phases[index], object: object)));
  }
}
