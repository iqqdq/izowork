// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';

class CompaniesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Company> _companies = [];
  Company? _company;
  CompaniesFilter? _companiesFilter;

  List<Company> get companies => _companies;

  Company? get company => _company;

  CompaniesFilter? get companiesFilter => _companiesFilter;

  CompaniesViewModel() {
    getCompanyList(
      pagination: Pagination(offset: 0, size: 50),
      search: '',
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _companies.clear();
    }

    await CompanyRepository()
        .getCompanies(
          pagination: pagination,
          search: search,
          params: _companiesFilter?.params,
        )
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
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void updateCompany(
    int index,
    Company? company,
  ) {
    if (company == null) return;

    _companies[index] = company;
    Future.delayed(const Duration(milliseconds: 300), () => notifyListeners());
  }

  void setFiler(CompaniesFilter companiesFilter) {
    _companiesFilter = companiesFilter;
    notifyListeners();
  }

  void resetFilter() {
    _companiesFilter = null;
  }
}
