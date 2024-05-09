import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/services/web_service.dart';

class DocumentRepository {
  Future<dynamic> getDocuments(
      {required Pagination pagination,
      required String namespace,
      required String id,
      required String search,
      List<String>? params}) async {
    var url =
        documentUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (namespace.isNotEmpty) {
      url += '&namespace=$namespace';
    }

    if (id.isNotEmpty) {
      url += '&id=$id';
    }

    if (search.isNotEmpty) {
      url += '&q=$search';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await WebService().get(url);
    List<Document> documents = [];

    try {
      json['documents'].forEach((element) {
        documents.add(Document.fromJson(element));
      });
      return documents;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }
}
