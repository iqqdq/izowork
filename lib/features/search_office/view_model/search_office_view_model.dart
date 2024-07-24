// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class SearchOfficeViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Office> _offices = [];

  List<Office> get offices => _offices;

  SearchOfficeViewModel() {
    getOfficeList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getOfficeList({
    required Pagination pagination,
    String? search,
  }) async {
    if (pagination.offset == 0) {
      _offices.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<OfficeRepositoryInterface>()
        .getOffices(
          pagination: pagination,
          search: search,
        )
        .then((response) => {
              if (response is List<Office>)
                {
                  if (_offices.isEmpty)
                    {
                      response.forEach((office) {
                        _offices.add(office);
                      })
                    }
                  else
                    {
                      response.forEach((newOffice) {
                        bool found = false;

                        _offices.forEach((office) {
                          if (newOffice.id == office.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _offices.add(newOffice);
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
