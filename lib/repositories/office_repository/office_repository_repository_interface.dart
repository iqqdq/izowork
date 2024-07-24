import 'package:izowork/components/components.dart';

abstract class OfficeRepositoryInterface {
  Future<dynamic> getOffices({
    required Pagination pagination,
    String? search,
  });
}
