// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/documents/documents_filter_sheet/documents_filter_page_view_screen_body.dart';
import 'package:izowork/api/api.dart';

class DocumentsViewModel with ChangeNotifier {
  final String? id;
  final String? namespace;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<Document> _documents = [];

  DocumentsFilter? _documentsFilter;

  List<Document> get documents => _documents;

  DocumentsFilter? get documentsFilter => _documentsFilter;

  int _downloadIndex = -1;

  int get downloadIndex => _downloadIndex;

  DocumentsViewModel(this.id, this.namespace) {
    getDealList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _documents.clear();
    }

    await DocumentRepository()
        .getDocuments(
          pagination: pagination,
          namespace: namespace ?? 'object',
          id: id ?? '',
          search: search,
          params: _documentsFilter?.params,
        )
        .then((response) => {
              if (response is List<Document>)
                {
                  if (_documents.isEmpty)
                    {
                      response.forEach((document) {
                        _documents.add(document);
                      })
                    }
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future openFile(int index) async {
    final type = namespace ?? 'object';
    final filename = _documents[index].filename;
    if (filename == null) return;

    FileDownloadHelper().download(
        url: baseUrl + 'resourses/$type-file/' + filename,
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

  void resetFilter() {
    _documentsFilter = null;
  }
}
