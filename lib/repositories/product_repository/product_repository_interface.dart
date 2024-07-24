import 'package:izowork/components/components.dart';

abstract class ProductRepositoryInterface {
  Future<dynamic> getProduct(String id);

  Future<dynamic> getProducts({
    required Pagination pagination,
    required String search,
    String? companyId,
    List<String>? params,
  });

  Future<dynamic> getProductTypes();
}
