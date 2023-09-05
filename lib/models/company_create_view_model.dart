// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/company_request.dart';
import 'package:izowork/entities/request/contact_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/company_type.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/repositories/company_repository.dart';
import 'package:izowork/repositories/contact_repository.dart';
import 'package:izowork/repositories/product_repository.dart';
import 'package:izowork/screens/contacts/contacts_screen.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyCreateViewModel with ChangeNotifier {
  final Company? selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Company? _company;

  CompanyType? _companyType;

  String? _phone;

  String? _type;

  final List<ProductType> _productTypes = [];

  ProductType? _productType;

  File? _file;

  CompanyType? get companyType {
    return _companyType;
  }

  List<ProductType> get productTypes {
    return _productTypes;
  }

  ProductType? get productType {
    return _productType;
  }

  Company? get company {
    return _company;
  }

  String? get phone {
    return _phone;
  }

  String? get type {
    return _type;
  }

  File? get file {
    return _file;
  }

  CompanyCreateViewModel(this.selectedCompany) {
    if (selectedCompany != null) {
      _company = selectedCompany;
      _phone = selectedCompany?.phone;
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
            {_companyType = response, getProductTypeList()}
          else
            loadingStatus = LoadingStatus.error,
        });
  }

  Future getProductTypeList() async {
    await ProductRepository().getProductTypes().then((response) => {
          if (response is List<ProductType>)
            {
              response.forEach((productType) {
                _productTypes.add(productType);
              }),
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  Future createNewCompany(
      BuildContext context,
      String address,
      String name,
      String phone,
      String? description,
      String? details,
      String? email,
      Function(Company) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await CompanyRepository()
        .createCompany(CompanyRequest(
            address: address,
            name: name,
            phone: phone,
            type: _type,
            description: description,
            details: details,
            email: email,
            productTypeId: _productType?.id))
        .then((response) async => {
              if (response is Company)
                {
                  _company = response,

                  // CHECK IF FILE SELECTED
                  if (_file != null)
                    await changeCompanyAvatar(context, _file!, response.id)
                        .then((value) => {
                              onCreate(response),
                            })
                  else
                    onCreate(response),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
            })
        .then((value) => notifyListeners());
  }

  Future editCompany(
      BuildContext context,
      String address,
      String name,
      String phone,
      String? description,
      String? details,
      String? email,
      Function(Company) onCreate) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await CompanyRepository()
        .updateCompany(CompanyRequest(
            id: _company?.id,
            address: address,
            name: name,
            phone: phone,
            type: _type ?? _company?.type,
            description: description,
            details: details,
            email: email,
            productTypeId: _productType?.id ?? _company?.productType?.id))
        .then((response) => {
              if (response is Company)
                {
                  _company = response,

                  // CHECK IF FILE SELECTED
                  if (_file == null)
                    onCreate(_company!)
                  else
                    changeCompanyAvatar(context, _file!, response.id)
                        .then((value) => {
                              onCreate(response),
                            })
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
            })
        .then((value) => notifyListeners());
  }

  Future changeCompanyAvatar(BuildContext context, File file, String id) async {
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
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .then((value) => notifyListeners());
  }

  Future updateContactInfo(
    BuildContext context,
    Contact contact,
  ) async {
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

      Future.delayed(
          const Duration(seconds: 1),
          () async => {
                loadingStatus = LoadingStatus.searching,
                notifyListeners(),
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
                              Toast().showTopToast(
                                  context, response.message ?? 'Ошибка'),
                              loadingStatus = LoadingStatus.error
                            }
                        })
                    .then((value) => notifyListeners())
              });
    }
  }

  // MARK: -
  // MARK: ACTIONS

  void showCompanyTypeSelectionSheet(BuildContext context) {
    if (_companyType != null) {
      if (_companyType!.states.isNotEmpty) {
        List<String> items = [];
        _companyType!.states.forEach((element) {
          items.add(element);
        });

        showCupertinoModalBottomSheet(
            enableDrag: false,
            topRadius: const Radius.circular(16.0),
            barrierColor: Colors.black.withOpacity(0.6),
            backgroundColor: HexColors.white,
            context: context,
            builder: (context) => SelectionScreenWidget(
                title: Titles.productType,
                value: _type ?? selectedCompany?.type ?? '',
                items: items,
                onSelectTap: (type) => {
                      _companyType!.states.forEach((element) {
                        if (type == element) {
                          _type = element;
                          notifyListeners();
                        }
                      })
                    }));
      }
    }
  }

  void showContactSelectionSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ContactsScreenWidget(
            company: _company,
            onPop: (contact) => {
                  updateContactInfo(context, contact),
                }));
  }

  void showProductTypeSelectionSheet(BuildContext context) {
    if (_productTypes.isNotEmpty) {
      List<String> items = [];
      _productTypes.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.productType,
              value: _productType?.name ??
                  selectedCompany?.productType?.name ??
                  '',
              items: items,
              onSelectTap: (type) => {
                    _productTypes.forEach((element) {
                      if (type == element.name) {
                        _productType = element;
                        notifyListeners();
                      }
                    })
                  }));
    }
  }

  Future pickImage(BuildContext context) async {
    final XFile? xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (xFile != null) {
      _file = File(xFile.path);
      notifyListeners();

      if (selectedCompany != null && _file != null) {
        changeCompanyAvatar(context, _file!, selectedCompany!.id);
      }
    }
  }

  void openUrl(String url) async {
    if (url.isNotEmpty) {
      String? nativeUrl;

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
          openBrowser(url);
        }
      } else {
        if (nativeUrl != null) {
          openBrowser(nativeUrl);
        } else {
          openBrowser(url);
        }
      }
    }
  }

  void openBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else if (await canLaunchUrl(
        Uri.parse('https://' + url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
    }
  }
}
