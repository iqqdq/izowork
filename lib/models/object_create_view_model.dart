// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_type.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/screens/phase/phase_screen.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class ObjectCreateViewModel with ChangeNotifier {
  // INIT
  final Object? object;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isKiso = false;
  bool _isCreateFolder = false;
  final List<String> _phases = [
    'Фундамент',
    'Стены',
    'Кровля',
    'Стяжка',
    'Перегородки',
    'Вентиляция',
    'Дымоудаление',
    'Водопровод',
    'Отопление',
    'Тепловые узлы'
  ];

  ObjectType? _objectType;

  List<ObjectType> _objectTypes = [];

  ObjectStage? _objectStage;

  List<ObjectStage> _objectStages = [];

  Company? _designer;

  Company? _customer;

  Company? _contractor;

  final List<Document> _documents = [];

  final List<File> _files = [];

  int _downloadIndex = -1;

  int current = 0;

  bool get isKiso {
    return _isKiso;
  }

  bool get isCreateFolder {
    return _isCreateFolder;
  }

  List<String> get phases {
    return _phases;
  }

  List<Document> get documents {
    return _documents;
  }

  List<File> get files {
    return _files;
  }

  ObjectStage? get objectStage {
    return _objectStage;
  }

  List<ObjectStage> get objectStages {
    return _objectStages;
  }

  ObjectType? get objectType {
    return _objectType;
  }

  List<ObjectType> get objectTypes {
    return _objectTypes;
  }

  Company? get designer {
    return _designer;
  }

  Company? get customer {
    return _customer;
  }

  Company? get contractor {
    return _contractor;
  }

  int get downloadIndex {
    return _downloadIndex;
  }

  ObjectCreateViewModel(this.object) {
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
                    if (object?.objectTypeId == element.id) {
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
                    if (object?.objectStageId == element.id) {
                      _objectStage = element;
                      return;
                    }
                  })
                }
            })
        .then((value) => notifyListeners());
  }

  Future deleteFile(BuildContext context, int index) async {
    if (object == null) {
      _files.removeAt(index);
      notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await ObjectRepository()
          .deleteObjectFile(DeleteRequest(id: object!.files[index].id))
          .then((response) => {
                if (response == true)
                  {
                    loadingStatus = LoadingStatus.completed,
                    _documents.removeAt(index)
                  }
                else if (response is ErrorResponse)
                  {
                    loadingStatus = LoadingStatus.error,
                    Toast().showTopToast(context, response.message ?? 'Ошибка')
                  },
                notifyListeners()
              });
    }
  }

  // MARK: -
  // MARK: - ACTIONS

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

    if (result != null) {
      debugPrint(result.files.length.toString());
    }
  }

  void checkKiso() {
    _isKiso = !_isKiso;
    notifyListeners();
  }

  void checkCreateFolder() {
    _isCreateFolder = !_isCreateFolder;
    notifyListeners();
  }

  Future openFile(BuildContext context, int index) async {
    if (object == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      String url = objectMediaUrl + object!.files[index].filename;

      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName =
            object?.files[index].name ?? object!.files[index].name;
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          _downloadIndex = index;
          notifyListeners();

          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
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
  }

  // MARK: -
  // MARK: - PUSH

  void showTypeSelectionScreenSheet(BuildContext context) {
    if (_objectTypes.isNotEmpty) {
      List<String> items = [];
      _objectTypes.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.status,
              items: items,
              onSelectTap: (type) => {
                    _objectTypes.forEach((element) {
                      if (type == element.name) {
                        _objectType = element;
                        notifyListeners();
                      }
                    })
                  }));
    }
  }

  void showStageSelectionScreenSheet(BuildContext context) {
    if (_objectStages.isNotEmpty) {
      List<String> items = [];
      _objectStages.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.stage,
              items: items,
              onSelectTap: (stage) => {
                    _objectStages.forEach((element) {
                      if (stage == element.name) {
                        _objectStage = element;
                        notifyListeners();
                      }
                    })
                  }));
    }
  }

  void showSearchCompanyScreenSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchCompanyScreenWidget(
            title: index == 0
                ? Titles.generalContractor
                : index == 1
                    ? Titles.developer
                    : index == 2
                        ? Titles.customer
                        : Titles.designer,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  index == 0
                      ? _contractor = company
                      : index == 1
                          ? debugPrint(index.toString())
                          : index == 2
                              ? _customer = company
                              : _designer = company,
                  notifyListeners(),
                  Navigator.pop(context),
                }));
  }

  void showPhaseScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhaseScreenWidget(phase: Phase())));
  }
}
