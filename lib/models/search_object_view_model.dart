// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/repositories/object_repository.dart';

class SearchObjectViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Object> _objects = [];

  List<Object> get objects => _objects;

  SearchObjectViewModel() {
    getObjectList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getObjectList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _objects.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await ObjectRepository()
        .getObjects(pagination: pagination, search: search ?? '')
        .then((response) => {
              if (response is List<Object>)
                {
                  if (_objects.isEmpty)
                    {
                      response.forEach((object) {
                        _objects.add(object);
                      })
                    }
                  else
                    {
                      response.forEach((newObject) {
                        bool found = false;

                        _objects.forEach((object) {
                          if (newObject.id == object.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _objects.add(newObject);
                        }
                      })
                    },
                  loadingStatus = LoadingStatus.completed
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }
}
