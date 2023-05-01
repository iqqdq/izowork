// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/trace_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/trace.dart';
import 'package:izowork/repositories/trace_repository.dart';
import 'package:izowork/screens/object/object_actions/object_action_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:izowork/entities/response/object.dart';

class ObjectActionsViewModel with ChangeNotifier {
  final Object object;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<Trace> _traces = [];

  List<Trace> get traces {
    return _traces;
  }

  ObjectActionsViewModel(this.object) {
    getTraceList(pagination: Pagination(offset: 0, size: 50));
  }

  // MARK: -
  // MARK: - API CALL

  Future getTraceList({required Pagination pagination}) async {
    if (pagination.offset == 0) {
      loadingStatus = LoadingStatus.searching;
      _traces.clear();

      Future.delayed(Duration.zero, () async {
        loadingStatus = LoadingStatus.searching;
        notifyListeners();
      });
    }

    await TraceRepository()
        .getTraces(pagination: pagination, objectId: object.id)
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

  Future addObjectTrace(
      BuildContext context, Pagination pagination, String text) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TraceRepository()
        .doAction(TraceRequest(action: text, objectId: object.id))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  Toast().showTopToast(context, Titles.actionAdded)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .then((value) => getTraceList(pagination: pagination));
  }

  // MARK: -
  // MARK: - PUSH

  void showActionCreateScreen(BuildContext context, Pagination pagination) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ObjectActionCreateSheetWidget(
            onTap: (text) => {
                  Navigator.pop(context),
                  addObjectTrace(context, pagination, text)
                }));
  }
}
