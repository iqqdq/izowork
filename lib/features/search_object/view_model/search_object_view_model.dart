// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class SearchObjectViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<MapObject> _objects = [];

  List<MapObject> get objects => _objects;

  SearchObjectViewModel() {
    getObjectList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getObjectList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      _objects.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<ObjectRepositoryInterface>()
        .getObjects(
          pagination: pagination,
          search: search ?? '',
        )
        .then((response) => {
              if (response is List<MapObject>)
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
