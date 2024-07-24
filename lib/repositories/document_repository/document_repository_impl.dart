import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

import 'document_repository_interface.dart';

class DocumentRepositoryImpl implements DocumentRepositoryInterface {
  // MARK: - COMMON FILE'S

  @override
  Future<dynamic> getDocuments({
    required Pagination pagination,
    required String? officeId,
    required String? folderId,
    List<String>? params,
  }) async {
    var url =
        documentsUrl + '?offset=${pagination.offset}&limit=${pagination.size}';

    if (officeId != null) {
      url += '&office_id=$officeId';
    }

    if (folderId != null) {
      url += '&folder_id=$folderId';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Document> documents = [];

    if (json['documents'] == null) return documents;

    try {
      json['documents'].forEach((element) {
        documents.add(Document.fromJson(element));
      });
      return documents;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createCommonFolder(
      CommonFolderRequest commonFolderRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      commonFolderCreateUrl,
      commonFolderRequest.toJson(),
    );

    try {
      return Document.fromJson(json["document"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> pinCommonFolder(
    bool isPinned,
    FolderPinRequest folderPinRequest,
  ) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      isPinned ? commonFolderUnpinUrl : commonFolderPinUrl,
      folderPinRequest.toJson(),
      null,
    );

    try {
      return Document.fromJson(json["folder"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteCommonFolder(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      commonFolderDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createCommonFile(CommonFileRequest commonFileRequest) async {
    dynamic json = await sl<WebServiceInterface>().postFormData(
      commonFileCreateUrl,
      await commonFileRequest.toFormData(),
    );

    try {
      return Document.fromJson(json["file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteCommonFile(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      commonFileDeleteUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  // MARK: - OBJECT FILE'S

  @override
  Future<dynamic> getObjectDocuments({
    required Pagination pagination,
    required String? objectId,
    required String? folderId,
    List<String>? params,
  }) async {
    var url = objectDocumentsUrl +
        '?offset=${pagination.offset}&limit=${pagination.size}';

    if (objectId != null) {
      url += '&object_id=$objectId';
    }

    if (folderId != null) {
      url += '&folder_id=$folderId';
    }

    if (params != null) {
      for (var element in params) {
        url += element;
      }
    }

    dynamic json = await sl<WebServiceInterface>().get(url);
    List<Document> documents = [];

    if (json['documents'] == null) return documents;

    try {
      json['documents'].forEach((element) {
        documents.add(Document.fromJson(element));
      });
      return documents;
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createObjectFolder(
      ObjectFolderRequest objectFolderRequest) async {
    dynamic json = await sl<WebServiceInterface>().post(
      objectFolderUrl,
      objectFolderRequest.toJson(),
    );

    try {
      return Document.fromJson(json["document"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> pinObjectFolder(
    bool isPinned,
    FolderPinRequest folderPinRequest,
  ) async {
    dynamic json = await sl<WebServiceInterface>().patch(
      isPinned ? objectFolderUnpinUrl : objectFolderPinUrl,
      folderPinRequest.toJson(),
      null,
    );

    try {
      return Document.fromJson(json["document"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteObjectFolder(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      objectFolderUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> createObjectFile(ObjectFileRequest objectFileRequest) async {
    dynamic json = await sl<WebServiceInterface>().postFormData(
      objectFileUrl,
      await objectFileRequest.toFormData(),
    );

    try {
      return Document.fromJson(json["object_file"]);
    } catch (e) {
      return ErrorResponse.fromJson(json);
    }
  }

  @override
  Future<dynamic> deleteObjectFile(DeleteRequest deleteRequest) async {
    dynamic json = await sl<WebServiceInterface>().delete(
      objectFileUrl,
      deleteRequest.toJson(),
    );

    if (json == true) {
      return json;
    } else {
      return ErrorResponse.fromJson(json);
    }
  }
}
