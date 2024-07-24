// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

class DealCreateViewModel with ChangeNotifier {
  final Deal? deal;
  final MapObject? selectedObject;
  final Phase? selectedPhase;

  final DateTime _minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime _maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  bool isUpdated = false;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  DateTime _startDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime _endDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  User? _responsible;

  MapObject? _object;

  Company? _company;

  List<DealProduct> _dealProducts = [];

  List<Document> _documents = [];

  final List<File> _files = [];

  List<Phase> _phases = [];

  Phase? _phase;

  int _downloadIndex = -1;

  User? get responsible => _responsible;

  MapObject? get object => _object;

  Company? get company => _company;

  List<DealProduct> get dealProducts => _dealProducts;

  DateTime get minDateTime => _minDateTime;

  DateTime get maxDateTime => _maxDateTime;

  DateTime get startDateTime => _startDateTime;

  DateTime get endDateTime => _endDateTime;

  List<Document> get documents => _documents;

  List<File> get files => _files;

  List<Phase> get phases => _phases;

  Phase? get phase => _phase;

  int get downloadIndex => _downloadIndex;

  DealCreateViewModel(
    this.deal,
    this.selectedPhase,
    this.selectedObject,
  ) {
    if (deal != null) {
      _startDateTime = deal!.createdAt;
      _endDateTime = deal!.finishAt;

      if (deal!.files.isNotEmpty) {
        _documents = deal!.files;
      }

      _object = deal!.object;
      _phase = selectedPhase;

      isUpdated = true;
    } else {
      _object = selectedObject;
      _phase = selectedPhase;
    }

    notifyListeners();

    if (deal != null) {
      getDealProductList().then((value) => {
            if (deal!.object != null) {getPhaseList(deal!.object!.id)}
          });
    }
  }

  // MARK: -
  // MARK: - API CALL

  Future createNewDeal(
    String? comment,
    Function(Deal) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    int current = 0;

    await sl<DealRepositoryInterface>()
        .createDeal(DealRequest(
          closed: false,
          comment: comment,
          companyId: _company?.id,
          objectId: _object?.id,
          responsibleId: _responsible?.id,
          phaseId: _phase?.id,
          createdAt: _startDateTime.toUtc().toLocal().toIso8601String() + 'Z',
          finishAt: _endDateTime.toUtc().toLocal().toIso8601String() + 'Z',
        ))
        .then((response) => {
              if (response is Deal)
                {
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        await uploadFile(response.id, element).then((value) => {
                              current++,
                              if (current == _files.length) onCreate(response)
                            });
                      })
                    }
                  else
                    onCreate(response)
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future editDeal(
    String? comment,
    Function(Deal) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .updateDeal(DealRequest(
          closed: false,
          id: deal!.id,
          comment: comment,
          companyId: _company?.id ?? deal!.companyId,
          objectId: selectedObject?.id ?? deal!.objectId,
          responsibleId: _responsible?.id ?? deal!.responsibleId,
          phaseId: _phase?.id ?? selectedPhase?.name,
          createdAt: _startDateTime.toUtc().toLocal().toIso8601String() + 'Z',
          finishAt: _endDateTime.toUtc().toLocal().toIso8601String() + 'Z',
        ))
        .then((response) => {
              if (response is Deal)
                onCreate(response)
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future getDealProductList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .getProduts(deal!.id)
        .then((response) => {
              if (response is List<DealProduct>)
                {
                  loadingStatus = LoadingStatus.completed,
                  _dealProducts = response,
                }
              else if (response is ErrorResponse)
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future getPhaseList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
        .getPhases(id)
        .then((response) => {
              if (response is List<Phase>)
                {
                  _phases = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future addDealProduct() async {
    if (deal == null) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .addProduct(DealProductRequest(count: 0, dealId: deal!.id))
        .then((response) => {
              if (response is DealProduct)
                {
                  loadingStatus = LoadingStatus.completed,
                  _dealProducts.add(response),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateDealProduct(
    int index,
    String id,
    String productId,
    int count,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DealRepositoryInterface>()
        .updateProduct(DealProductRequest(
          count: count,
          id: id,
          dealId: deal!.id,
          productId: productId,
        ))
        .then((response) => {
              if (response is DealProduct)
                {
                  _dealProducts[index] = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteDealProduct(int index) async {
    if (deal != null && _dealProducts.isNotEmpty) {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await sl<DealRepositoryInterface>()
          .deleteProduct(DeleteRequest(id: _dealProducts[index].id))
          .then((response) => {
                if (response == true)
                  {
                    loadingStatus = LoadingStatus.completed,
                    _dealProducts.removeAt(index)
                  }
              })
          .whenComplete(() => notifyListeners());
    }
  }

  Future uploadFile(
    String id,
    File file,
  ) async {
    await sl<DealRepositoryInterface>()
        .addDealFile(DealFileRequest(id, file))
        .then((response) => {
              if (response is Document) _documents.add(response),
            });
  }

  Future deleteFile(int index) async {
    if (deal == null) {
      _files.removeAt(index);
      notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await sl<DealRepositoryInterface>()
          .deleteDealFile(DeleteRequest(id: deal!.files[index].id))
          .then((response) => {
                if (response == true)
                  {
                    loadingStatus = LoadingStatus.completed,
                    _documents.removeAt(index)
                  }
              })
          .whenComplete(() => notifyListeners());
    }
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changePhase(String? stage) {
    for (var element in phases) {
      if (stage == element.name) {
        _phase = element;
        notifyListeners();
      }
    }
  }

  void changeStartDateTime(DateTime dateTime) {
    _startDateTime = dateTime;
    notifyListeners();
  }

  void changeEndDateTime(DateTime dateTime) {
    _endDateTime = dateTime;
    notifyListeners();
  }

  void changeResponsible(User user) {
    _responsible = user;
    notifyListeners();
  }

  void changeObject(MapObject? object) {
    _object = object;
    _phase = null;
  }

  void changeCompany(Company? company) {
    _company = company;
    notifyListeners();
  }

  void changeProduct(
    int index,
    Product? product,
  ) {
    if (product == null) return;

    _dealProducts[index].product = product;
    _dealProducts[index].productId = product.id;
  }

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      if (result.files.isNotEmpty) {
        if (deal == null) {
          result.files.forEach((element) {
            if (element.path != null) {
              _files.add(File(element.path!));
              notifyListeners();
            }
          });
        } else {
          loadingStatus = LoadingStatus.searching;
          notifyListeners();

          int current = 0;

          result.files.forEach((element) async {
            if (element.path != null) {
              await uploadFile(deal!.id, File(element.path!)).then((value) => {
                    current++,
                    if (current == result.files.length)
                      {
                        loadingStatus = LoadingStatus.completed,
                        notifyListeners()
                      }
                  });
            }
          });
        }
      }
    }
  }

  Future openFile(int index) async {
    if (deal == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);
      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(Titles.unsupportedFileFormat);
      }
    } else {
      if (deal!.files[index].filename == null) return;
      final filename = deal!.files[index].filename!;

      await sl<FileDownloadServiceInterface>().download(
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
  }

  void changeProductWeight(
    int index,
    int weight,
  ) {
    _dealProducts[index].count = weight;
    updateDealProduct(
      index,
      _dealProducts[index].id,
      _dealProducts[index].productId!,
      weight,
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS
}
