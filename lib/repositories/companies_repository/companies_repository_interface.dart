import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';

abstract class CompaniesRepositoryInterface {
  Future<dynamic> getCompanies({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getMapCompanies({
    required List<String> params,
    required LatLngBounds? visibleRegion,
  });
}
