import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'product_repository_interface.dart';

class ProductRepositoryImpl implements ProductRepositoryInterface {
  @override
  Future<dynamic> getProduct(String id) async {
    dynamic json = await sl<WebServiceInterface>().get(productUrl + id);

    try {
      return Product.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getProducts(
      {required Pagination pagination,
      required String search,
      String? companyId,
      List<String>? params}) async {
    var url =
        productsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (companyId != null) {
      url += '&company_id=$companyId';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Product> products = [];

    try {
      json['products'].forEach((element) {
        products.add(Product.fromJson(element));
      });
      return products;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getProductTypes() async {
    dynamic json = await sl<WebServiceInterface>().get(productTypesUrl);
    List<ProductType> productTypes = [];

    try {
      json['types'].forEach((element) {
        productTypes.add(ProductType.fromJson(element));
      });
      return productTypes;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
