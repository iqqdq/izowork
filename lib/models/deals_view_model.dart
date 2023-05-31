// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/screens/deal_calendar/deal_calendar_screen.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter_page_view_screen.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Deal> _deals = [];
  DealsFilter? _dealsFilter;

  List<Deal> get deals {
    return _deals;
  }

  DealsViewModel() {
    getDealList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

  Future getDealById(String id) async {
    loadingStatus = LoadingStatus.searching;

    await DealRepository().getDeal(id).then((response) => {
          if (response is Deal)
            {
              _deals.insert(0, response),
              loadingStatus = LoadingStatus.completed,
            }
          else
            {loadingStatus = LoadingStatus.error},
          notifyListeners()
        });
  }

  Future getDealList(
      {required Pagination pagination, required String search}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _deals.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }
    await DealRepository()
        .getDeals(
            pagination: pagination,
            search: search,
            params: _dealsFilter?.params)
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    _dealsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showCalendarScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCalendarScreenWidget()));
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealCreateScreenWidget(
                onCreate: (deal, dealProducts) => {
                      if (deal != null) {getDealById(deal.id)}
                    })));
  }

  void showDealsFilterSheet(BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealsFilterPageViewScreenWidget(
            dealsFilter: _dealsFilter,
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
                      _dealsFilter = objectsFilter,
                      onFilter()
                    }
                }));
  }

  void showDealScreenWidget(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealScreenWidget(deal: _deals[index])));
  }
}
