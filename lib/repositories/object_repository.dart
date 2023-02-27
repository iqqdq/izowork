import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/request/object_file_request.dart';
import 'package:izowork/entities/request/object_request.dart';
import 'package:izowork/entities/response/document.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_type.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class ObjectRepository {
  Future<dynamic> getObjectTypes() async {
    dynamic json = await WebService().get(objectTypesUrl);
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

  Future<dynamic> getObjectStages() async {
    dynamic json = await WebService().get(objectStatesUrl);
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

  Future<dynamic> getObject(String id) async {
    dynamic json = await WebService().get(objectUrl + '?id=$id');

    try {
      return Object.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> getObjects(
      {required Pagination pagination,
      required String search,
      List<String>? params}) async {
    var url =
        objectsUrl + '?&offset=${pagination.offset}&limit=${pagination.size}';

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Object> objects = [];

    try {
      json['objects'].forEach((element) {
        objects.add(Object.fromJson(element));
      });
      return objects;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> createObject(ObjectRequest objectRequest) async {
    dynamic json = await WebService().post(objectCreateUrl, objectRequest);

    try {
      return Object.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> updateObject(ObjectRequest objectRequest) async {
    dynamic json = await WebService().patch(objectUpdateUrl, objectRequest);

    try {
      return Object.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> addObjectFile(ObjectFileRequest objectFileRequest) async {
    dynamic json = await WebService()
        .postFormData(taskFileUrl, await objectFileRequest.toFormData());

    try {
      return Document.fromJson(json["object_file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  Future<dynamic> deleteObjectFile(DeleteRequest deleteRequest) async {
    dynamic json = await WebService().delete(objectMediaUrl, deleteRequest);

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json).message ?? 'Ошибка';
    }
  }
}
