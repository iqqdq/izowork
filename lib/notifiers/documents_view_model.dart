// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/documents/documents_filter_sheet/documents_filter_page_view_screen.dart';
import 'package:izowork/screens/documents/documents_filter_sheet/documents_filter_page_view_screen_body.dart';
import 'package:izowork/screens/documents/documents_screen.dart';
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

  Future openFile(BuildContext context, int index) async {
    String type = namespace ?? 'object';
    String url =
        baseUrl + 'resourses/$type-file/' + (_documents[index].filename ?? '');

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = _documents[index].filename ?? '';
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        }).then((value) => {_downloadIndex = -1, notifyListeners()});
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse(url.replaceAll(' ', '')));
      } else if (await canLaunchUrl(
          Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      }
    }
  }

  void resetFilter() {
    _documentsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void openFolder(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DocumentsScreenWidget(
                  id: _documents[index].id,
                  title: _documents[index].name,
                  namespace: _documents[index].namespace,
                )));
  }

  void showDocumentsFilterSheet(
    BuildContext context,
    Function() onFilter,
  ) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => DocumentsFilterPageViewScreenWidget(
            documentsFilter: _documentsFilter,
            onPop: (contactsFilter) => {
                  if (contactsFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _documentsFilter = contactsFilter,
                      onFilter()
                    }
                }));
  }
}
