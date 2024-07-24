// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class CompanyActionsViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  final List<CompanyAction> _companyActions = [];

  List<CompanyAction> get companyActions => _companyActions;

  CompanyActionsViewModel(this.id) {
    getCompanyActions(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getCompanyActions({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _companyActions.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<CompanyRepositoryInterface>()
        .getCompanyActions(
          pagination: pagination,
          companyId: id,
        )
        .then((response) => {
              if (response is List<CompanyAction>)
                {
                  if (_companyActions.isEmpty)
                    {
                      response.forEach((companyAction) {
                        _companyActions.add(companyAction);
                      })
                    }
                  else
                    {
                      response.forEach((newCompnayAction) {
                        bool found = false;

                        _companyActions.forEach((companyAction) {
                          if (newCompnayAction.id == companyAction.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _companyActions.add(newCompnayAction);
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

  Future addCompanyAction(String description) async {
    if (description.isEmpty) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    String? userId =
        (await sl<LocalStorageRepositoryInterface>().getUser())?.id;

    await sl<CompanyRepositoryInterface>()
        .createCompanyAction(CompanyActionRequest(
          companyId: id,
          description: description,
          userId: userId,
        ))
        .then((response) => {
              if (response is CompanyAction)
                {
                  _companyActions.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                }
              else if (response is ErrorResponse)
                {
                  Toast().showTopToast(response.message ?? 'Произошла ошибка'),
                  loadingStatus = LoadingStatus.error,
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
