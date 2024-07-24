// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/features/analytics/view/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_page_view_screen_body.dart';

class AnalyticsActionsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Trace> _traces = [];

  AnalyticsActionsFilter? _analyticsActionsFilter;

  List<Trace> get traces => _traces;

  AnalyticsActionsFilter? get analyticsActionsFilter => _analyticsActionsFilter;

  AnalyticsActionsViewModel() {
    getTraceList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getTraceList({
    required Pagination pagination,
    String? objectId,
    String? subjectId,
    String? group,
    String? type,
  }) async {
    if (pagination.offset == 0) {
      _traces.clear();
    }

    await sl<TraceRepositoryInterface>()
        .getTraces(
          pagination: pagination,
          objectId: objectId,
          subjectId: subjectId,
          group: group,
          type: type,
          params: _analyticsActionsFilter?.params,
        )
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
            })
        .whenComplete(() => notifyListeners());
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void setFilter(
    String search,
    AnalyticsActionsFilter? analyticsActionsFilter,
  ) {
    _analyticsActionsFilter = analyticsActionsFilter;

    getTraceList(pagination: Pagination());
  }

  void resetFilter() => _analyticsActionsFilter = null;
}
