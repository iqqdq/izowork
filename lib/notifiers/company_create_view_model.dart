import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/repositories/repositories.dart';

class CompanyCreateViewModel with ChangeNotifier {
  final Company? selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Company? _company;

  CompanyType? _companyType;

  String? _bim;

  String? _type;

  final List<ProductType> _productTypes = [];

  ProductType? _productType;

  File? _file;

  CompanyType? get companyType => _companyType;

  List<ProductType> get productTypes => _productTypes;

  ProductType? get productType => _productType;

  Company? get company => _company;

  String? get bim => _bim;

  String? get type => _type;

  File? get file => _file;

  CompanyCreateViewModel(this.selectedCompany) {
    if (selectedCompany != null) {
      _company = selectedCompany;
      _bim = selectedCompany?.bim;
      _productType = selectedCompany?.productType;
      notifyListeners();
    }

    getCompanyTypeList();
  }

  // MARK: -
  // MARK: API CALL

  Future getCompanyTypeList() async {
    await CompanyRepository().getCompanyTypes().then((response) => {
          if (response is CompanyType)
            {
              _companyType = response,
              getProductTypeList(),
            }
          else
            {
              loadingStatus = LoadingStatus.error,
              notifyListeners(),
            }
        });
  }

  Future getProductTypeList() async {
    await ProductRepository()
        .getProductTypes()
        .then((response) => {
              if (response is List<ProductType>)
                {
                  for (var element in response) _productTypes.add(element),
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .then((value) => notifyListeners());
  }

  Future createNewCompany(
    String address,
    String coord,
    String name,
    String phone,
    String? description,
    String? details,
    String? email,
    Function(Company) onCreate,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    double? lat;
    double? long;

    if (coord.characters.length > 8 &&
        coord.contains('.') &&
        coord.contains(',')) {
      lat = double.tryParse(coord.split(',')[0]);
      long = double.tryParse(coord.split(',')[1]);
    }

    await CompanyRepository()
        .createCompany(CompanyRequest(
          address: address,
          lat: lat,
          long: long,
          name: name,
          phone: phone,
          type: _type,
          description: description,
          details: details,
          email: email,
          productTypeId: _productType?.id,
        ))
        .then((response) async => {
              if (response is Company)
                {
                  _company = response,

                  // CHECK IF FILE SELECTED
                  if (_file != null)
                    await changeCompanyAvatar(
                      _file!,
                      response.id,
                    ).then((value) => onCreate(response))
                  else
                    onCreate(response),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future editCompany(
      String address,
      String coord,
      String name,
      String phone,
      String? description,
      String? details,
      String? email,
      Function(Company) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    double? lat;
    double? long;

    if (coord.characters.length > 8 &&
        coord.contains('.') &&
        coord.contains(',')) {
      lat = double.tryParse(coord.split(',')[0]);
      long = double.tryParse(coord.split(',')[1]);
    }

    await CompanyRepository()
        .updateCompany(CompanyRequest(
          id: _company?.id,
          address: address,
          lat: lat,
          long: long,
          name: name,
          phone: phone,
          type: _type ?? _company?.type,
          description: description,
          details: details,
          email: email,
          productTypeId: _productType?.id ?? _company?.productType?.id,
        ))
        .then((response) => {
              if (response is Company)
                {
                  _company = response,

                  // CHECK IF FILE SELECTED
                  if (_file == null)
                    onCreate(_company!)
                  else
                    changeCompanyAvatar(
                      _file!,
                      response.id,
                    ).then((value) => onCreate(response))
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future changeCompanyAvatar(
    File file,
    String id,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    FormData formData = dio.FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path,
          filename:
              file.path.substring(file.path.length - 8, file.path.length)),
      "id": id
    });

    await CompanyRepository()
        .updateCompanyAvatar(formData)
        .then((response) => {
              if (response == true)
                loadingStatus = LoadingStatus.completed
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateContactInfo(Contact contact) async {
    bool found = false;

    _company?.contacts.forEach((element) {
      if (element.id == contact.id) {
        found = true;
      }
    });

    if (!found) {
      ContactRequest contactRequest = ContactRequest(
        companyId: _company?.id,
        id: contact.id,
        name: contact.name,
        post: contact.post,
        email: contact.email,
        phone: contact.phone,
        social: contact.social,
      );

      loadingStatus = LoadingStatus.searching;
      notifyListeners();

      await ContactRepository()
          .updateContact(contactRequest)
          .then((response) => {
                if (response is Contact)
                  {
                    _company?.contacts.add(response),
                    loadingStatus = LoadingStatus.completed,
                    notifyListeners(),
                  }
                else if (response is ErrorResponse)
                  {
                    Toast()
                        .showTopToast(response.message ?? 'Произошла ошибка'),
                    loadingStatus = LoadingStatus.error
                  }
              })
          .then((value) => notifyListeners());
    }
  }

  // MARK: -
  // MARK: FUNCTIONS

  void changeCompanyType(String type) {
    if (_companyType == null) return;

    for (var element in _companyType!.states) {
      if (type == element) {
        _type = element;
        notifyListeners();
      }
    }
  }

  void changeProductType(String type) {
    for (var element in _productTypes) {
      if (type == element.name) {
        _productType = element;
        notifyListeners();
      }
    }
  }

  Future pickImage() async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (xFile != null) {
      _file = File(xFile.path);
      notifyListeners();

      if (selectedCompany == null || _file == null) return;

      changeCompanyAvatar(
        _file!,
        selectedCompany!.id,
      );
    }
  }

  void openUrl(String url) async {
    if (url.isNotEmpty) {
      String? nativeUrl;
      WebViewHelper webViewHelper = WebViewHelper();

      if (url.contains('t.me')) {
        nativeUrl = 'tg:resolve?domain=${url.replaceAll('t.me/', '')}';
      } else if (url.characters.first == '@') {
        nativeUrl = 'instagram://user?username=${url.replaceAll('@', '')}';
      }

      if (Platform.isAndroid) {
        if (nativeUrl != null) {
          AndroidIntent intent = AndroidIntent(
              action: 'android.intent.action.VIEW', data: nativeUrl);

          if ((await intent.canResolveActivity()) == true) {
            await intent.launch();
          }
        } else {
          webViewHelper.open(url);
        }
      } else {
        nativeUrl != null
            ? webViewHelper.open(nativeUrl)
            : webViewHelper.open(url);
      }
    }
  }
}
