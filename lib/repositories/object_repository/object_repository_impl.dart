import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'object_repository_interface.dart';

class ObjectRepositoryImpl implements ObjectRepositoryInterface {
  @override
  Future<dynamic> getObjectTypes() async {
    dynamic json = await sl<WebServiceInterface>().get(objectTypesUrl);
    List<ObjectType> objectTypes = [];

    try {
      json['types'].forEach((element) {
        objectTypes.add(ObjectType.fromJson(element));
      });
      return objectTypes;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getObjectStages() async {
    dynamic json = await sl<WebServiceInterface>().get(objectStatesUrl);
    List<ObjectStage> objectStages = [];

    try {
      json['stages'].forEach((element) {
        objectStages.add(ObjectStage.fromJson(element));
      });
      return objectStages;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getObject(String id) async {
    dynamic json = await sl<WebServiceInterface>().get(objectUrl + id);

    try {
      return MapObject.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getObjects({
    required Pagination pagination,
    required String search,
    List<String>? params,
  }) async {
    var url =
        objectsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<MapObject> objects = [];

    try {
      json['objects'].forEach((element) {
        objects.add(MapObject.fromJson(element));
      });
      return objects;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> getMapObjects({
    required List<String> params,
    required LatLngBounds? visibleRegion,
  }) async {
    var url = objectsUrl;

    if (visibleRegion != null) {
      url +=
          '?lat=gte:${visibleRegion.southwest.latitude}&lat=lte:${visibleRegion.northeast.latitude}&long=gte:${visibleRegion.southwest.longitude}&long=lte:${visibleRegion.northeast.longitude}';
    }

    if (params.isNotEmpty) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<MapObject> objects = [];

    try {
      json['objects'].forEach((element) {
        objects.add(MapObject.fromJson(element));
      });
      return objects;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createObject(ObjectRequest objectRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      objectCreateUrl,
      objectRequest.toJson(),
    );

    try {
      return MapObject.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> updateObject(ObjectRequest objectRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      objectUpdateUrl,
      objectRequest.toJson(),
      null,
    );

    try {
      return MapObject.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> changeObjectStage(
      ObjectStageRequest objectStageRequest) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      objectChangeStatusUrl,
      objectStageRequest.toJson(),
      null,
    );

    if (json["success"] == true) {
      return true;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
