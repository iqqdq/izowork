// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/repositories/company_repository.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_page_view_widget.dart';
import 'package:izowork/screens/company/company_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CompaniesViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Company> _companies = [];
  Company? _company;
  // CompaniesFilter? _companiesFilter;

  List<Company> get companies {
    return _companies;
  }

  Company? get company {
    return _company;
  }

  // CompaniesFilter? get companiesFilter {
  //   return _companiesFilter;
  // }

  CompaniesViewModel() {
    getCompanyList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;

    await CompanyRepository().getCompany(id).then((response) => {
          if (response is Company)
            {
              _company = response,
              loadingStatus = LoadingStatus.completed,
            }
          else if (response is ErrorResponse)
            {
              loadingStatus = LoadingStatus.error,
              Toast().showTopToast(context, response.message ?? 'Ошибка')
            },
          notifyListeners()
        });
  }

  Future getCompanyList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _companies.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await CompanyRepository()
        .getCompanies(
          pagination: pagination,
          search: search,
          // params: _companiesFilter?.params
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    // _companiesFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showCompanyPageViewScreen(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CompanyScreenWidget(company: _companies[index])));
  }

  void showCompaniesFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => CompaniesFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }
}
