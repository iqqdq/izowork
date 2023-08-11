// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/object_stage.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/object_create/object_create_screen.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Object> _objects = [];

  Object? _object;
  ObjectsFilter? _objectsFilter;
  List<ObjectStage>? _objectStages;

  List<Object> get objects {
    return _objects;
  }

  Object? get object {
    return _object;
  }

  ObjectsFilter? get objectsFilter {
    return _objectsFilter;
  }

  List<ObjectStage>? get objectStages {
    return _objectStages;
  }

  ObjectsViewModel() {
    getStageList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getStageList() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository()
        .getObjectStages()
        .then((response) => {
              if (response is List<ObjectStage>) {_objectStages = response}
            })
        .then((value) => getObjectList(
            pagination: Pagination(offset: 0, size: 50), search: ''));
  }

  Future getObjectList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _objects.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await ObjectRepository()
        .getObjects(
            pagination: pagination,
            search: search,
            params: _objectsFilter?.params)
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  // Future sortByName() async {
  //   if (_objectsFilter == null) {
  //     _objectsFilter =
  //         ObjectsFilter(null, null, null, [], [], ['&sortBy=name']);
  //   } else {
  //     if (!_objectsFilter!.params.contains('&sortBy=name')) {
  //       _objectsFilter!.params.add('&sortBy=name');
  //     }
  //   }
  // }

  // Future sortByEfficiency() async {
  //   if (_objectsFilter == null) {
  //     _objectsFilter =
  //         ObjectsFilter(null, null, null, [], [], ['&sortBy=efficiency']);
  //   } else {
  //     if (!_objectsFilter!.params.contains('&sortBy=efficiency')) {
  //       _objectsFilter!.params.add('&sortBy=efficiency');
  //     }
  //   }
  // }

  void resetFilter() {
    _objectsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showObjectsFilterSheet(BuildContext context, Function() onFilter) {
    if (_objectStages != null) {
      showCupertinoModalBottomSheet(
          enableDrag: false,
          topRadius: const Radius.circular(16.0),
          barrierColor: Colors.black.withOpacity(0.6),
          backgroundColor: HexColors.white,
          context: context,
          builder: (context) => ObjectsFilterPageViewScreenWidget(
              objectStages: _objectStages!,
              objectsFilter: _objectsFilter,
              onPop: (objectsFilter) => {
                    if (objectsFilter == null)
                      {
                        // CLEAR
                        resetFilter(),
                        onFilter()
                      }
                    else
                      {
                        // FILTER
                        _objectsFilter = objectsFilter,
                        onFilter()
                      }
                  }));
    }
  }

  void showObjectPageViewScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ObjectPageViewScreenWidget(object: _objects[index])));
  }

  void showObjectCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectCreateScreenWidget(
                onCreate: (object) => Toast()
                    .showTopToast(context, '${Titles.object} добавлен!'))));
  }
}
