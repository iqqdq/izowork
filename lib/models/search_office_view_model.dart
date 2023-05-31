// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/repositories/office_repository.dart';

class SearchOfficeViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Office> _offices = [];

  List<Office> get offices {
    return _offices;
  }

  SearchOfficeViewModel() {
    getOfficeList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getOfficeList({required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _offices.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await OfficeRepository()
        .getOffices(pagination: pagination, search: search)
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
              notifyListeners()
            });
  }
}
