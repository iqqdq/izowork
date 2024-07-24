// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class ObjectActionsViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Trace> _traces = [];

  List<Trace> get traces => _traces;

  ObjectActionsViewModel(this.id) {
    getTraceList(pagination: Pagination());
  }

  // MARK: -
  // MARK: - API CALL

  Future getTraceList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      _traces.clear();

      loadingStatus = LoadingStatus.searching;
      notifyListeners();
    }

    await sl<TraceRepositoryInterface>()
        .getTraces(
          pagination: pagination,
          objectId: id,
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

  Future addObjectTrace(String text) async {
    if (text.isEmpty) return;

    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<TraceRepositoryInterface>()
        .createAction(TraceRequest(
          action: text,
          objectId: id,
        ))
        .then((response) => {
              if (response is Trace)
                {
                  loadingStatus = LoadingStatus.completed,
                  _traces.insert(0, response),
                }
            })
        .whenComplete(() => notifyListeners());
  }
}
