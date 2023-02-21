// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/repositories/product_repository.dart';
import 'package:izowork/screens/selection/selection_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CompanyCreateViewModel with ChangeNotifier {
  final Company? selectedCompany;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<ProductType> _productTypes = [];
  ProductType? _productType;

  List<ProductType> get productTypes {
    return _productTypes;
  }

  ProductType? get productType {
    return _productType;
  }

  Company? _company;

  Company? get company {
    return _company;
  }

  CompanyCreateViewModel(this.selectedCompany) {
    getProductTypeList();
  }

  // MARK: -
  // MARK: API CALL

  Future getProductTypeList() async {
    await ProductRepository().getProductTypes().then((response) => {
          if (response is List<ProductType>)
            {
              if (_productTypes.isEmpty)
                {
                  response.forEach((productType) {
                    _productTypes.add(productType);
                  })
                }
              else
                {
                  response.forEach((newProductType) {
                    bool found = false;

                    _productTypes.forEach((productType) {
                      if (newProductType.id == productType.id) {
                        found = true;
                      }
                    });

                    if (!found) {
                      _productTypes.add(newProductType);
                    }
                  })
                },
              loadingStatus = LoadingStatus.completed
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: ACTIONS

  void showProductTypeSelectionSheet(BuildContext context) {
    if (_productTypes.isNotEmpty) {
      List<String> items = [];
      _productTypes.forEach((element) {
        items.add(element.name);
      });

      showCupertinoModalBottomSheet(
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => SelectionScreenWidget(
              title: Titles.productType,
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
      // changeAvatar(context, File(xFile.path));
    }
  }
}
