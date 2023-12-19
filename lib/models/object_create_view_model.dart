import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/request/object_file_request.dart';
import 'package:izowork/entities/request/object_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_type.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_office/search_office_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/services/urls.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class ObjectCreateViewModel with ChangeNotifier {
  final Object? object;

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

  bool get isKiso {
    return _isKiso;
  }

  bool get hideDir {
    return _hideDir;
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

  User? get techManager {
    return _techManager;
  }

  Office? get office {
    return _office;
  }

  User? get manager {
    return _manager;
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
        .then((value) => notifyListeners());
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
      Function(Object) onCreate) async {
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
                kiso: kiso))
            .then((response) => {
                  if (response is Object)
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
                      Toast()
                          .showTopToast(context, response.message ?? 'Ошибка')
                    },
                  notifyListeners()
                });
      }
    } else {
      Toast().showTopToast(context, Titles.wrongCoordFormat);
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
      Function(Object) onCreate) async {
    if (coord.characters.length > 8 &&
        coord.contains('.') &&
        coord.contains(',')) {
      double? lat = double.tryParse(coord.split(',')[0]);
      double? long = double.tryParse(coord.split(',')[1]);

      if (lat != null && long != null) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        late Object newObject;

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
                kiso: kiso))
            .then((response) => {
                  if (response is Object)
                    {
                      newObject = response,
                      newObject.office = _office ?? object?.office,
                      onCreate(newObject),
                    }
                  else if (response is ErrorResponse)
                    {
                      loadingStatus = LoadingStatus.error,
                      Toast()
                          .showTopToast(context, response.message ?? 'Ошибка')
                    },
                  notifyListeners()
                });
      } else {
        Toast().showTopToast(context, Titles.wrongCoordFormat);
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
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
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
                    Toast().showTopToast(context, response.message ?? 'Ошибка')
                  },
                notifyListeners()
              });
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

  Future openFile(BuildContext context, int index) async {
    if (object == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      String url = objectMediaUrl + (_documents[index].filename ?? '');

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

  void showSearchCompanySheet(BuildContext context, int index) {
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
  }

  void showSearchOfficeSheet(BuildContext context) {
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
}
