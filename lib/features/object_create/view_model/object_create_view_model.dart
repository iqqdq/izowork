// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class ObjectCreateViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final MapObject? object;

  final List<File> _files = [];

  List<File> get files => _files;

  bool _isKiso = true;

  bool get isKiso => _isKiso;

  bool _hideDir = true;

  bool get hideDir => _hideDir;

  ObjectType? _objectType;

  ObjectType? get objectType => _objectType;

  List<ObjectType> _objectTypes = [];

  List<ObjectType> get objectTypes => _objectTypes;

  ObjectStage? _objectStage;

  ObjectStage? get objectStage => _objectStage;

  List<ObjectStage> _objectStages = [];

  List<ObjectStage> get objectStages => _objectStages;

  User? _techManager;

  User? get techManager => _techManager;

  Office? _office;

  Office? get office => _office;

  User? _manager;

  User? get manager => _manager;

  Company? _designer;

  Company? get designer => _designer;

  Company? _customer;

  Company? get customer => _customer;

  Company? _contractor;

  Company? get contractor => _contractor;

  List<Document> _documents = [];

  List<Document> get documents => _documents;

  int _downloadIndex = -1;

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
    await sl<ObjectRepositoryInterface>()
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
        .whenComplete(() => notifyListeners());
  }

  Future getStageList() async {
    await sl<ObjectRepositoryInterface>()
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

        int current = 0;

        await sl<ObjectRepositoryInterface>()
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
                            await uploadFile(response.id, element).then(
                                (value) => {
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
                          .showTopToast(response.message ?? 'Произошла ошибка')
                    },
                })
            .whenComplete(() => notifyListeners());
      }
    } else {
      Toast().showTopToast(Titles.wrongCoordFormat);
    }
  }

  Future editObject(
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

        await sl<ObjectRepositoryInterface>()
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
                      Toast()
                          .showTopToast(response.message ?? 'Произошла ошибка')
                    },
                })
            .whenComplete(() => notifyListeners());
      } else {
        Toast().showTopToast(Titles.wrongCoordFormat);
      }
    }
  }

  Future uploadFile(
    String id,
    File file,
  ) async {
    await sl<DocumentRepositoryInterface>()
        .createObjectFile(ObjectFileRequest(
          objectId: id,
          file: file,
        ))
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            });
  }

  Future deleteObjectFile(int index) async {
    if (object == null) {
      _files.removeAt(index);
      notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await sl<DocumentRepositoryInterface>()
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
                    Toast().showTopToast(response.message ?? 'Произошла ошибка')
                  },
              })
          .whenComplete(() => notifyListeners());
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void checkKiso() {
    _isKiso = !_isKiso;
    notifyListeners();
  }

  void checkCreateFolder() {
    _hideDir = !_hideDir;
    notifyListeners();
  }

  void changeObjectStage(ObjectStage? objectStage) {
    if (objectStage == null) return;
    _objectStage = objectStage;

    notifyListeners();
  }

  void changeObjectType(ObjectType? objectType) {
    if (objectType == null) return;
    _objectType = objectType;

    notifyListeners();
  }

  void changeTechManager(User? user) {
    if (user == null) return;
    _techManager = user;

    notifyListeners();
  }

  void changeManager(User? user) {
    if (user == null) return;
    _manager = user;

    notifyListeners();
  }

  void changeCustomer(Company? company) {
    if (company == null) return;
    _customer = company;

    notifyListeners();
  }

  void changeContractor(Company? company) {
    if (company == null) return;
    _contractor = company;

    notifyListeners();
  }

  void changeDesigner(Company? company) {
    if (company == null) return;
    _designer = company;

    notifyListeners();
  }

  void changeOffice(Office? office) {
    if (office == null) return;
    _office = office;

    notifyListeners();
  }

  Future addFile() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();

    if (selectedImages != null) {
      if (selectedImages.isNotEmpty) {
        for (var element in selectedImages) {
          _files.add(File(element.path));
        }
      }
    }

    if (object == null) {
      if (_files.isNotEmpty) notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      int current = 0;

      _files.forEach((element) async {
        await uploadFile(object!.id, element).then((value) => {
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

  Future openFile(int index) async {
    if (object == null) {
      if ((await OpenFilex.open(_files[index].path)).type ==
          ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      final filename = _documents[index].filename;
      if (filename == null) return;

      await sl<FileDownloadServiceInterface>().download(
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
}
