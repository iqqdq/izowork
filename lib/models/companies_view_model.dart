// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/responses/company.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_screen_body.dart';
import 'package:izowork/screens/company/company_screen.dart';
import 'package:izowork/screens/company_create/company_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  void resetFilter() {
    _companiesFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showCompanyPageViewScreen(
    BuildContext context,
    int index,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompanyScreenWidget(
                company: _companies[index],
                onPop: (company) => {
                      if (company != null)
                        {
                          _companies.removeWhere(
                            (element) => element.id == company.id,
                          ),
                          _companies.insert(index, company),
                          notifyListeners()
                        }
                    })));
  }

  void showCompaniesFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => CompaniesFilterPageViewScreenWidget(
            companiesFilter: _companiesFilter,
            onPop: (companiesFilter) => {
                  if (companiesFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _companiesFilter = companiesFilter,
                      onFilter()
                    }
                }));
  }

  void showCreateCompanyScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CompanyCreateScreenWidget(onPop: null),
        ));
  }
}
