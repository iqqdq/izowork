// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/documents/view/documents_filter_sheet/documents_filter_page_view_screen_body.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/services/services.dart';

class DocumentsViewModel with ChangeNotifier {
  final String? objectId;
  // final String? officeId;
  final Document? document;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  String? _officeId;
  String? get officeId => _officeId;

  List<Office> _offices = [];
  List<Office> get offices => _offices;

  final List<Document> _documents = [];
  List<Document> get documents => _documents;

  DocumentsFilter? _documentsFilter;
  DocumentsFilter? get documentsFilter => _documentsFilter;

  int _downloadIndex = -1;
  int get downloadIndex => _downloadIndex;

  DocumentsViewModel(
    this.objectId,
    this.document,
  ) {
    setOffices().whenComplete(() => objectId == null
        ? getDocuments(pagination: Pagination())
        : getObjectDocuments(
            pagination: Pagination(),
            objectId: objectId,
          ));
  }

  // MARK: -
  // MARK: - API CALL COMMON FILE'S

  Future getDocuments({
    required Pagination pagination,
    List<String>? params,
  }) async {
    if (pagination.offset == 0) {
      _documents.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<DocumentRepositoryInterface>()
        .getDocuments(
          pagination: pagination,
          officeId: _officeId,
          folderId: document?.id,
          params: _documentsFilter?.params,
        )
        .then((response) => {
              if (response is List<Document>)
                {
                  if (_documents.isEmpty)
                    _documents.addAll(response)
                  else
                    {
                      response.forEach((newDocument) {
                        bool found = false;

                        _documents.forEach((document) {
                          if (newDocument.id == document.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _documents.add(newDocument);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => _sortDocuments());
  }

  Future createCommonFolder(String name) async {
    if (name.isEmpty) return;
    if (_offices.length < 2) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .createCommonFolder(CommonFolderRequest(
          isCommon: _officeId == null,
          name: name,
          officeId: _officeId == null ? _offices[1].id! : _officeId!,
          parentFolder: document?.id,
        ))
        .then((response) => {
              if (response is Document)
                {
                  _documents.add(response),
                  _sortDocuments(),
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future pinCommonFolder(
    bool isPinned,
    String id,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .pinCommonFolder(
          isPinned,
          FolderPinRequest(folderId: id),
        )
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents[_documents.indexWhere(
                      (element) => element.id == response.id)] = response,
                  _sortDocuments(),
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners(),
            });
  }

  Future deleteCommonFolder(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .deleteCommonFolder(DeleteRequest(id: id))
        .then((response) => {
              if (response == true)
                {
                  _documents.removeWhere((element) => element.id == id),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future createCommonFile(CommonFileRequest commonFileRequest) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .createCommonFile(commonFileRequest)
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response),
                  _sortDocuments(),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            });
  }

  Future deleteCommonFile(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .deleteCommonFile(DeleteRequest(id: id))
        .then((response) => {
              if (response == true)
                {
                  _documents.removeWhere((element) => element.id == id),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - API CALL OBJECT FILE'S

  Future getObjectDocuments({
    required Pagination pagination,
    required String? objectId,
    List<String>? params,
  }) async {
    if (pagination.offset == 0) {
      _documents.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<DocumentRepositoryInterface>()
        .getObjectDocuments(
          pagination: pagination,
          objectId: objectId,
          folderId: document?.id,
          params: _documentsFilter?.params,
        )
        .then((response) => {
              if (response is List<Document>)
                {
                  if (_documents.isEmpty)
                    _documents.addAll(response)
                  else
                    {
                      response.forEach((newDocument) {
                        bool found = false;

                        _documents.forEach((document) {
                          if (newDocument.id == document.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _documents.add(newDocument);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => _sortDocuments());
  }

  Future createObjectFolder(String name) async {
    if (objectId == null) return;
    if (name.isEmpty) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .createObjectFolder(ObjectFolderRequest(
          name: name,
          objectId: objectId!,
          parentFolder: document?.id,
        ))
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response),
                  _sortDocuments(),
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future pinObjectFolder(
    bool isPinned,
    String id,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .pinObjectFolder(
          isPinned,
          FolderPinRequest(folderId: id),
        )
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents[_documents.indexWhere(
                      (element) => element.id == response.id)] = response,
                  _sortDocuments(),
                }
              else
                loadingStatus = LoadingStatus.error,
              notifyListeners(),
            });
  }

  Future deleteObjectFolder(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .deleteObjectFolder(DeleteRequest(id: id))
        .then((response) => {
              if (response == true)
                {
                  _documents.removeWhere((element) => element.id == id),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future createObjectFile(ObjectFileRequest objectFileRequest) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .createObjectFile(objectFileRequest)
        .then((response) => {
              if (response is Document)
                {
                  loadingStatus = LoadingStatus.completed,
                  _documents.add(response),
                  _sortDocuments(),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            });
  }

  Future deleteObjectFile(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<DocumentRepositoryInterface>()
        .deleteObjectFile(DeleteRequest(id: id))
        .then((response) => {
              if (response == true)
                {
                  _documents.removeWhere((element) => element.id == id),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                }
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future setOffices() async {
    User? user = await sl<LocalStorageRepositoryInterface>().getUser();

    if (user == null) return;
    if (user.offices == null) return;

    _offices = user.offices ?? [];
    _offices.insert(0, Office(id: null, name: 'Все'));
    _offices.insert(2,
        Office(id: '21f25da3-ffbc-48a0-a5c9-a1c6b00b6a21', name: 'Караганда'));

    _officeId = _offices.first.id;

    notifyListeners();
  }

  void selectOffice(int index) {
    _officeId = _offices[index].id;
  }

  void _sortDocuments() {
    _documents
        .sort((a, b) => b.pinned.toString().compareTo(a.pinned.toString()));
    loadingStatus = LoadingStatus.completed;

    notifyListeners();
  }

  Future addFile() async {
    if (_offices.length < 2) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      if (result.files.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();

        result.files.forEach((element) async {
          if (element.path != null) {
            // IF OBJECT FILE'S
            if (objectId != null) {
              await createObjectFile(ObjectFileRequest(
                objectId: objectId!,
                folderId: document?.id,
                file: File(element.path!),
              ));
              // IF COMMON FILE'S
            } else {
              await createCommonFile(CommonFileRequest(
                officeId: _officeId == null ? _offices[1].id! : _officeId!,
                folderId: document?.id,
                isCommon: _officeId == null,
                file: File(element.path!),
              ));
            }
          }
        });
      }
    }
  }

  Future openDocument(int index) async {
    final filename = _documents[index].filename;
    if (filename == null) return;

    await sl<FileDownloadServiceInterface>().download(
        url: baseUrl +
            (objectId == null
                ? 'resources/common-file/'
                : 'resources/object-file/') +
            filename,
        filename: filename,
        onDownload: () => {
              _downloadIndex = index,
              notifyListeners(),
            },
        onComplete: () => {
              _downloadIndex = -1,
              notifyListeners(),
            });
  }

  void updateFilter(DocumentsFilter filter) {
    _documentsFilter = filter;
    notifyListeners();
  }

  void resetFilter() => _documentsFilter = null;
}
