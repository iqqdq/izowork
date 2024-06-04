// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_office/search_office_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/api/api.dart';

class ObjectCreateViewModel with ChangeNotifier {
  final MapObject? object;

  final List<File> _files = [];

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isKiso = true;

  bool _hideDir = true;

  ObjectType? _objectType;

  List<ObjectType> _objectTypes = [];

  ObjectStage? _objectStage;

  List<ObjectStage> _objectStages = [];

  User? _techManager;

  Office? _office;

  User? _manager;

  Company? _designer;

  Company? _customer;

  Company? _contractor;

  List<Document> _documents = [];

  int _downloadIndex = -1;

  int current = 0;

  bool get isKiso => _isKiso;

  bool get hideDir => _hideDir;

  List<Document> get documents => _documents;

  List<File> get files => _files;

  ObjectStage? get objectStage => _objectStage;

  List<ObjectStage> get objectStages => _objectStages;

  ObjectType? get objectType => _objectType;

  List<ObjectType> get objectTypes => _objectTypes;

  User? get techManager => _techManager;

  Office? get office => _office;

  User? get manager => _manager;

  Company? get designer => _designer;

  Company? get customer => _customer;

  Company? get contractor => _contractor;

  int get downloadIndex => _downloadIndex;

  ObjectCreateViewModel(this.object) {
    if (object != null) {
      _office = object?.office;

      _isKiso = object!.kiso == null
          ? false
          : object!.kiso!.isEmpty
              ? false
              : true;

      _hideDir = object!.hideDir;

      _documents = object?.files ?? [];
    }

    getTypeList().then((value) => getStageList());
  }

  // MARK: -
  // MARK: - API CALL

  Future getTypeList() async {
    await ObjectRepository().getObjectTypes().then((response) => {
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
        });
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
        .whenComplete(() => notifyListeners());
  }

  Future createNewObject(
    BuildContext context,
    String address,
    int? area,
    int? constructionPeriod,
    int? floors,
    String coord,
    String name,
    String kiso,
    Function(MapObject) onCreate,
  ) async {
    if (coord.characters.length > 8 &&
        coord.contains('.') &&
        coord.contains(',')) {
      double? lat = double.tryParse(coord.split(',')[0]);
      double? long = double.tryParse(coord.split(',')[1]);

      if (lat != null && long != null) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        await ObjectRepository()
            .createObject(ObjectRequest(
              address: address,
              area: area,
              constructionPeriod: constructionPeriod,
              contractorId: _contractor?.id,
              customerId: _customer?.id,
              designerId: _designer?.id,
              managerId: _manager?.id,
              techManagerId: _techManager?.id,
              officeId: _office?.id,
              floors: floors,
              lat: lat,
              long: long,
              name: name,
              objectStageId: _objectStage!.id,
              objectTypeId: _objectType!.id,
              hideDir: _hideDir,
              kiso: kiso,
            ))
            .then((response) => {
                  if (response is MapObject)
                    {
                      if (_files.isNotEmpty)
                        {
                          _files.forEach((element) async {
                            await uploadFile(context, response.id, element)
                                .then((value) => {
                                      current++,
                                      if (current == _files.length)
                                        onCreate(response)
                                    });
                          })
                        }
                      else
                        onCreate(response)
                    }
                  else if (response is ErrorResponse)
                    {
                      loadingStatus = LoadingStatus.error,
                      Toast().showTopToast(response.message ?? 'Ошибка')
                    },
                })
            .whenComplete(() => notifyListeners());
      }
    } else {
      Toast().showTopToast(Titles.wrongCoordFormat);
    }
  }

  Future editObject(
    BuildContext context,
    String address,
    int? area,
    int? constructionPeriod,
    int? floors,
    String coord,
    String name,
    String kiso,
    Function(MapObject) onCreate,
  ) async {
    if (coord.characters.length > 8 &&
        coord.contains('.') &&
        coord.contains(',')) {
      double? lat = double.tryParse(coord.split(',')[0]);
      double? long = double.tryParse(coord.split(',')[1]);

      if (lat != null && long != null) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        late MapObject newObject;

        await ObjectRepository()
            .updateObject(ObjectRequest(
              id: object!.id,
              address: address,
              area: area ?? object?.area,
              constructionPeriod:
                  constructionPeriod ?? object?.constructionPeriod,
              managerId: _manager?.id ?? object?.managerId,
              contractorId: _contractor?.id ?? object?.contractorId,
              customerId: _customer?.id ?? object?.customerId,
              designerId: _designer?.id ?? object?.designerId,
              techManagerId: _techManager?.id,
              officeId: _office?.id,
              floors: floors ?? object?.floors,
              lat: lat,
              long: long,
              name: name,
              objectStageId: _objectStage?.id ?? object!.objectStageId!,
              objectTypeId: _objectType?.id ?? object!.objectTypeId!,
              hideDir: _hideDir,
              kiso: kiso,
            ))
            .then((response) => {
                  if (response is MapObject)
                    {
                      newObject = response,
                      newObject.office = _office ?? object?.office,
                      onCreate(newObject),
                    }
                  else if (response is ErrorResponse)
                    {
                      loadingStatus = LoadingStatus.error,
                      Toast().showTopToast(response.message ?? 'Ошибка')
                    },
                })
            .whenComplete(() => notifyListeners());
      } else {
        Toast().showTopToast(Titles.wrongCoordFormat);
      }
    }
  }

  Future uploadFile(BuildContext context, String id, File file) async {
    await ObjectRepository()
        .addObjectFile(ObjectFileRequest(id, file))
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Ошибка')
                }
            });
  }

  Future deleteObjectFile(BuildContext context, int index) async {
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
                    Toast().showTopToast(response.message ?? 'Ошибка')
                  },
              })
          .whenComplete(() => notifyListeners());
    }
  }

  // MARK: -
  // MARK: - ACTIONS

  Future addFile(BuildContext context) async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();

    if (selectedImages != null) {
      if (selectedImages.isNotEmpty) {
        for (var element in selectedImages) {
          _files.add(File(element.path));
        }
      }
    }

    if (object == null) {
      if (_files.isNotEmpty) {
        notifyListeners();
      }
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      _files.forEach((element) async {
        await uploadFile(context, object!.id, element).then((value) => {
              current++,
              if (current == _files.length)
                {
                  loadingStatus = LoadingStatus.completed,
                  notifyListeners(),
                }
            });
      });
    }
  }

  void checkKiso() {
    _isKiso = !_isKiso;
    notifyListeners();
  }

  void checkCreateFolder() {
    _hideDir = !_hideDir;
    notifyListeners();
  }

  Future openFile(int index) async {
    if (object == null) {
      if ((await OpenFilex.open(_files[index].path)).type ==
          ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      final filename = _documents[index].filename;
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
  }

  // MARK: -
  // MARK: - PUSH

  void showTypeSelectionSheet(BuildContext context) {
    if (_objectTypes.isNotEmpty) {
      List<String> items = [];
      _objectTypes.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SelectionScreenWidget(
              title: Titles.objectType,
              value: _objectType?.name ?? object?.objectType?.name ?? '',
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

  void showStageSelectionSheet(BuildContext context) {
    if (_objectStages.isNotEmpty) {
      List<String> items = [];
      _objectStages.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SelectionScreenWidget(
              title: Titles.stage,
              value: _objectStage?.name ?? object?.objectStage?.name ?? '',
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

  void showSearchUserSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchUserScreenWidget(
            title: index == 0 ? Titles.techManager : Titles.manager,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
                  index == 0 ? _techManager = user : _manager = user,
                  notifyListeners(),
                  Navigator.pop(context),
                }));
  }

  void showSearchCompanySheet(BuildContext context, int index) =>
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SearchCompanyScreenWidget(
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

  void showSearchOfficeSheet(BuildContext context) =>
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SearchOfficeScreenWidget(
              title: Titles.filial,
              isRoot: true,
              onFocus: () => {},
              onPop: (office) => {
                    _office = office,
                    notifyListeners(),
                    Navigator.pop(context),
                  }));
}
