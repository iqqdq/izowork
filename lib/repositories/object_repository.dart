import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/services/web_service.dart';

class ObjectRepository {
  Future<dynamic> getObject(String id) async {
    dynamic json = await WebService().get(objectUrl + '?id=$id');

    try {
      return Object.fromJson(json["object"]);
    } catch (e) {
      return ErrorResponse.fromJson(json).message ?? e.toString();
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
      return ErrorResponse.fromJson(json).message ?? e.toString();
    }
  }
}
