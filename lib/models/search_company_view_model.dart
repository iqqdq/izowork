// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/repositories/company_repository.dart';

class SearchCompanyViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Company> _companies = [];

  List<Company> get companies {
    return _companies;
  }

  SearchCompanyViewModel() {
    getCompanyList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyList(
      {required Pagination pagination, String? search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _companies.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await CompanyRepository()
        .getCompanies(pagination: pagination, search: search ?? '')
        .then((response) => {
              if (response is List<Company>)
                {
                  if (_companies.isEmpty)
                    {
                      response.forEach((company) {
                        _companies.add(company);
                      })
                    }
                  else
                    {
                      response.forEach((newCompany) {
                        bool found = false;

                        _companies.forEach((company) {
                          if (newCompany.id == company.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _companies.add(newCompany);
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
