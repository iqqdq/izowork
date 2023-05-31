import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/product.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class ProductRepository {
  Future<dynamic> getProduct(String id) async {
    dynamic json = await WebService().get(productUrl + id);

    try {
      return Product.fromJson(json["product"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

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

    dynamic json = await WebService().get(url);
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

  Future<dynamic> getProductTypes() async {
    dynamic json = await WebService().get(productTypesUrl);
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
