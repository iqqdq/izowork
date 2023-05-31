// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/company_request.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/company_type.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/repositories/company_repository.dart';
import 'package:izowork/repositories/product_repository.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CompanyCreateViewModel with ChangeNotifier {
  final Company? selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Company? _company;

  CompanyType? _companyType;

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

  String? get type {
    return _type;
  }

  File? get file {
    return _file;
  }

  CompanyCreateViewModel(this.selectedCompany) {
    if (selectedCompany != null) {
      _company = selectedCompany;
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
        .then((response) => {
              if (response is Company)
                {
                  _company = response,

                  // CHECK IF FILE SELECTED
                  if (_file == null)
                    onCreate(response)
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
                    onCreate(response)
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
              if (response)
                loadingStatus = LoadingStatus.completed
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .then((value) => notifyListeners());
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
}
