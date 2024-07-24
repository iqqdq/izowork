import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

abstract class DocumentRepositoryInterface {
  // MARK: - COMMON FILE'S

  Future<dynamic> getDocuments({
    required Pagination pagination,
    required String? officeId,
    required String? folderId,
    List<String>? params,
  });

  Future<dynamic> createCommonFolder(CommonFolderRequest commonFolderRequest);

  Future<dynamic> pinCommonFolder(
    bool isPinned,
    FolderPinRequest folderPinRequest,
  );

  Future<dynamic> deleteCommonFolder(DeleteRequest deleteRequest);

  Future<dynamic> createCommonFile(CommonFileRequest commonFileRequest);

  Future<dynamic> deleteCommonFile(DeleteRequest deleteRequest);

  // MARK: - OBJECT FILE'S

  Future<dynamic> getObjectDocuments({
    required Pagination pagination,
    required String? objectId,
    required String? folderId,
    List<String>? params,
  });

  Future<dynamic> createObjectFolder(ObjectFolderRequest objectFolderRequest);

  Future<dynamic> pinObjectFolder(
    bool isPinned,
    FolderPinRequest folderPinRequest,
  );

  Future<dynamic> deleteObjectFolder(DeleteRequest deleteRequest);

  Future<dynamic> createObjectFile(ObjectFileRequest objectFileRequest);

  Future<dynamic> deleteObjectFile(DeleteRequest deleteRequest);
}
