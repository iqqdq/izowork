// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen_body.dart';

class ObjectsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<MapObject> _objects = [];

  List<MapObject> get objects => _objects;

  Object? _object;

  Object? get object => _object;

  ObjectsFilter? _objectsFilter;

  ObjectsFilter? get objectsFilter => _objectsFilter;

  List<ObjectStage>? _objectStages;

  List<ObjectStage>? get objectStages => _objectStages;

  ObjectsViewModel() {
    getStageList().whenComplete(
      () => getObjectList(
          pagination: Pagination(offset: 0, size: 50), search: ''),
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getStageList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>) _objectStages = response,
            })
        .whenComplete(() => notifyListeners());
  }

  Future getObjectList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _objects.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await ObjectRepository()
        .getObjects(
          pagination: pagination,
          search: search,
          params: _objectsFilter?.params,
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

  // MARK: -
  // MARK: - FUNCTIONS

  void setFilter(ObjectsFilter? objectsFilter) {
    if (objectsFilter == null) return;
    _objectsFilter = objectsFilter;

    notifyListeners();
  }

  void resetFilter() {
    _objectsFilter = null;
  }
}
