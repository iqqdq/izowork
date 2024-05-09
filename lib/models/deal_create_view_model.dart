// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_object/search_object_screen.dart';
import 'package:izowork/screens/search_product/search_product_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DealCreateViewModel with ChangeNotifier {
  final Deal? deal;
  final Object? selectedObject;
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

  Object? _object;

  Company? _company;

  List<DealProduct> _dealProducts = [];

  List<Document> _documents = [];

  final List<File> _files = [];

  List<Phase> _phases = [];

  Phase? _phase;

  int _downloadIndex = -1;

  int current = 0;

  User? get responsible => _responsible;

  Object? get object => _object;

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
      _startDateTime = DateTime.parse(deal!.createdAt);
      _endDateTime = DateTime.parse(deal!.finishAt);

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
    BuildContext context,
    String? comment,
    Function(Deal) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
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
                        await uploadFile(context, response.id, element).then(
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
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future editDeal(
      BuildContext context, String? comment, Function(Deal) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository()
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
                {onCreate(response)}
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future getDealProductList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository().getProduts(deal!.id).then((response) => {
          if (response is List<DealProduct>)
            {
              loadingStatus = LoadingStatus.completed,
              _dealProducts = response,
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
            },
          notifyListeners()
        });
  }

  Future getPhaseList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
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

  Future addDealProduct(BuildContext context) async {
    if (deal != null) {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await DealRepository()
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
                    Toast().showTopToast(context, response.message ?? 'Ошибка')
                  }
              })
          .whenComplete(() => notifyListeners());
    }
  }

  Future updateDealProduct(
    BuildContext context,
    int index,
    String id,
    String productId,
    int count,
  ) async {
    // loadingStatus = LoadingStatus.searching;
    // notifyListeners();

    await DealRepository()
        .updateProduct(DealProductRequest(
            count: count, id: id, dealId: deal!.id, productId: productId))
        .then((response) => {
              if (response is DealProduct)
                {
                  _dealProducts[index] = response,
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteDealProduct(BuildContext context, int index) async {
    if (deal != null && _dealProducts.isNotEmpty) {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await DealRepository()
          .deleteProduct(DeleteRequest(id: _dealProducts[index].id))
          .then((response) => {
                if (response == true)
                  {
                    loadingStatus = LoadingStatus.completed,
                    _dealProducts.removeAt(index)
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

  Future uploadFile(BuildContext context, String id, File file) async {
    await DealRepository()
        .addDealFile(DealFileRequest(id, file))
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

  Future deleteFile(BuildContext context, int index) async {
    if (deal == null) {
      _files.removeAt(index);
      notifyListeners();
    } else {
      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await DealRepository()
          .deleteDealFile(DeleteRequest(id: deal!.files[index].id))
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc']);

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

          result.files.forEach((element) async {
            if (element.path != null) {
              await uploadFile(context, deal!.id, File(element.path!))
                  .then((value) => {
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

  Future openFile(BuildContext context, int index) async {
    if (deal == null) {
      OpenResult openResult = await OpenFilex.open(_files[index].path);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      String url = dealMediaUrl + (deal!.files[index].filename ?? '');

      if (Platform.isAndroid) {
        Directory appDocumentsDirectory =
            await getApplicationDocumentsDirectory();
        String appDocumentsPath = appDocumentsDirectory.path;
        String fileName = deal!.files[index].name;
        String filePath = '$appDocumentsPath/$fileName';
        bool isFileExists = await io.File(filePath).exists();

        if (!isFileExists) {
          _downloadIndex = index;
          notifyListeners();

          await Dio().download(url, filePath,
              onReceiveProgress: (count, total) {
            debugPrint('---Download----Rec: $count, Total: $total');
          }).whenComplete(() => {
                _downloadIndex = -1,
                notifyListeners(),
              });
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

  void changeProductWeight(
    BuildContext context,
    int index,
    int weight,
  ) {
    _dealProducts[index].count = weight;
    updateDealProduct(
      context,
      index,
      _dealProducts[index].id,
      _dealProducts[index].productId!,
      weight,
    );
  }

  // MARK: -
  // MARK: - PUSH

  void showSelectionSheet(BuildContext context) {
    if (_phases.isNotEmpty) {
      List<String> items = [];
      _phases.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (sheetContext) => SelectionScreenWidget(
              title: Titles.phase,
              value: _phase?.name ?? selectedPhase?.name ?? '',
              items: items,
              onSelectTap: (stage) => {
                    _phases.forEach((element) {
                      if (stage == element.name) {
                        _phase = element;
                        notifyListeners();
                      }
                    })
                  }));
    }
  }

  void showDateTimeSelectionSheet(BuildContext context, int index) {
    TextStyle textStyle = const TextStyle(
        overflow: TextOverflow.ellipsis, fontFamily: 'PT Root UI');

    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DateTimeWheelPickerWidget(
            minDateTime: _minDateTime,
            maxDateTime: _maxDateTime,
            initialDateTime: index == 0 ? _startDateTime : _endDateTime,
            showDays: true,
            locale: Platform.localeName,
            backgroundColor: HexColors.white,
            buttonColor: HexColors.primaryMain,
            buttonHighlightColor: HexColors.primaryDark,
            buttonTitle: Titles.apply,
            buttonTextStyle: textStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HexColors.black),
            selecteTextStyle: textStyle.copyWith(
                fontSize: 14.0,
                color: HexColors.black,
                fontWeight: FontWeight.w400),
            unselectedTextStyle: textStyle.copyWith(
                fontSize: 12.0,
                color: HexColors.grey70,
                fontWeight: FontWeight.w400),
            onTap: (dateTime) => {
                  Navigator.pop(context),
                  index == 0
                      ? _startDateTime = dateTime
                      : _endDateTime = dateTime,
                  notifyListeners(),
                }));
  }

  void showSearchUserSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchUserScreenWidget(
            title: Titles.responsible,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
                  _responsible = user,
                  notifyListeners(),
                  Navigator.pop(context)
                }));
  }

  void showSearchObjectSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchObjectScreenWidget(
            title: Titles.object,
            isRoot: true,
            onFocus: () => {},
            onPop: (object) => {
                  if (object != null)
                    {
                      _object = object,
                      _phases.clear(),
                      _phase = null,
                      getPhaseList(object.id)
                    },
                  Navigator.pop(context)
                }));
  }

  void showSearchCompanySheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchCompanyScreenWidget(
            title: Titles.company,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  _company = company,
                  notifyListeners(),
                  Navigator.pop(context)
                }));
  }

  void showSearchProductSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => SearchProductScreenWidget(
            isRoot: true,
            onFocus: () => {},
            onPop: (product) => {
                  Navigator.pop(context),
                  if (product != null)
                    {
                      _dealProducts[index].product = product,
                      _dealProducts[index].productId = product.id,
                      updateDealProduct(context, index, _dealProducts[index].id,
                              product.id, _dealProducts[index].count)
                          .then(
                        (value) => notifyListeners(),
                      )
                    }
                }));
  }
}
