// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/deals/view/deals_filter_sheet/deals_filter_page_view_screen_body.dart';

class DealsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Deal> _deals = [];

  List<Deal> get deals => _deals;

  DealsFilter? _dealsFilter;

  DealsFilter? get dealsFilter => _dealsFilter;

  DealsViewModel() {
    getDealList(
      pagination: Pagination(),
      search: '',
    );
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await sl<DealRepositoryInterface>()
        .getDeal(id)
        .then((response) => {
              if (response is Deal)
                {
                  _deals.insert(0, response),
                  loadingStatus = LoadingStatus.completed,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }

  Future getDealList({
    required Pagination pagination,
    required String search,
  }) async {
    if (pagination.offset == 0) {
      _deals.clear();

      if (search.isNotEmpty) {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();
      }
    }

    await sl<DealRepositoryInterface>()
        .getDeals(
          pagination: pagination,
          search: search,
          params: _dealsFilter?.params,
        )
        .then((response) => {
              if (response is List<Deal>)
                {
                  if (_deals.isEmpty)
                    {
                      response.forEach((deal) {
                        _deals.add(deal);
                      })
                    }
                  else
                    {
                      response.forEach((newDeal) {
                        bool found = false;

                        _deals.forEach((deal) {
                          if (newDeal.id == deal.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _deals.add(newDeal);
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

  void setFilter(
    String search,
    DealsFilter dealsFilter,
  ) {
    _dealsFilter = dealsFilter;
  }

  void resetFilter() => _dealsFilter = null;
}
