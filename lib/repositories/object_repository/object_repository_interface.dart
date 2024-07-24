import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class ObjectRepositoryInterface {
  Future<dynamic> getObjectTypes();

  Future<dynamic> getObjectStages();

  Future<dynamic> getObject(String id);

  Future<dynamic> getObjects({
    required Pagination pagination,
    required String search,
    List<String>? params,
  });

  Future<dynamic> getMapObjects({
    required List<String> params,
    required LatLngBounds? visibleRegion,
  });

  Future<dynamic> createObject(ObjectRequest objectRequest);

  Future<dynamic> updateObject(ObjectRequest objectRequest);

  Future<dynamic> changeObjectStage(ObjectStageRequest objectStageRequest);
}
