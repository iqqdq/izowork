// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter_page_view_widget.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/task_calendar/task_calendar_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DealsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Deal> _deals = [];

  List<Deal> get deals {
    return _deals;
  }

  DealsViewModel() {
    getDealList(pagination: Pagination(offset: 0, size: 50), search: '');
  }

  // MARK: -
  // MARK: - API CALL

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
          // params: _dealsFilter?.params
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
              notifyListeners()
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    // _dealsFilter = null;
  }

  // MARK: -
  // MARK: - PUSH

  void showCalendarScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TaskCalendarScreenWidget()));
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCreateScreenWidget()));
  }

  void showDealsFilterSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => DealsFilterPageViewWidget(
            onApplyTap: () => {Navigator.pop(context)},
            onResetTap: () => {Navigator.pop(context)}));
  }

  void showDealScreenWidget(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealScreenWidget(deal: _deals[index])));
  }
}