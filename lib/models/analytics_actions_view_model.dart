// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/trace.dart';
import 'package:izowork/repositories/trace_repository.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen_body.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AnalyticsActionsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Trace> _traces = [];

  AnalyticsActionsFilter? _analyticsActionsFilter;

  List<Trace> get traces {
    return _traces;
  }

  AnalyticsActionsFilter? get analyticsActionsFilter {
    return _analyticsActionsFilter;
  }

  AnalyticsActionsViewModel() {
    getTraceList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getTraceList(
      {required Pagination pagination,
      String? objectId,
      String? subjectId,
      String? group,
      String? type}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _traces.clear();

      Future.delayed(Duration.zero, () async {
        notifyListeners();
      });
    }

    await TraceRepository()
        .getTraces(
            pagination: pagination,
            objectId: objectId,
            subjectId: subjectId,
            group: group,
            type: type,
            params: _analyticsActionsFilter?.params)
        .then((response) => {
              if (response is List<Trace>)
                {
                  if (_traces.isEmpty)
                    {
                      response.forEach((trace) {
                        _traces.add(trace);
                      })
                    }
                  else
                    {
                      response.forEach((newTrace) {
                        bool found = false;

                        _traces.forEach((trace) {
                          if (newTrace.id == trace.id) {
                            found = true;
                          }
                        });

                        if (!found) {
                          _traces.add(newTrace);
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
  // MARK: - PUSH

  void showAnalyticsActionFilterSheet(
      BuildContext context, Function() onFilter) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => AnalyticsActionsFilterPageViewScreenWidget(
            analyticsActionsFilter: _analyticsActionsFilter,
            onPop: (analyticsActionsFilter) => {
                  if (analyticsActionsFilter == null)
                    {
                      // CLEAR
                      resetFilter(),
                      onFilter()
                    }
                  else
                    {
                      // FILTER
                      _analyticsActionsFilter = analyticsActionsFilter,
                      onFilter()
                    }
                }));
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void resetFilter() {
    _analyticsActionsFilter = null;
  }
}
