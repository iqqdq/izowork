// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/trace_request.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/news.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/task.dart';
import 'package:izowork/entities/response/trace.dart';
import 'package:izowork/repositories/deal_repository.dart';
import 'package:izowork/repositories/news_repository.dart';
import 'package:izowork/repositories/object_repository.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/repositories/task_repository.dart';
import 'package:izowork/repositories/trace_repository.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:izowork/screens/object/object_actions/object_action_create_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';
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
              if (response is Trace)
                {
                  loadingStatus = LoadingStatus.completed,
                  _traces.insert(0, response),
                  Toast().showTopToast(context, Titles.actionAdded)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            })
        .then((value) => notifyListeners());
  }

  Future getObjectById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await ObjectRepository().getObject(id).then((response) => {
          if (response is Object)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ObjectPageViewScreenWidget(object: response)))
                }
            }
          else if (response is ErrorResponse)
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  Future getDealById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await DealRepository().getDeal(id).then((response) => {
          if (response is Deal)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DealScreenWidget(deal: response)))
                }
            }
          else
            {loadingStatus = LoadingStatus.error, notifyListeners()}
        });
  }

  Future getTaskById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await TaskRepository().getTask(id).then((response) => {
          if (response is Task)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TaskScreenWidget(task: response)))
                }
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  Future getNewsById(BuildContext context, String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await NewsRepository().getNewsOne(id).then((response) => {
          if (response is News)
            {
              loadingStatus = LoadingStatus.completed,
              notifyListeners(),
              if (context.mounted)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewsPageScreenWidget(news: response, tag: '')))
                }
            }
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  Future getPhaseById(
      BuildContext context, String objectId, String phaseId) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository().getPhase(phaseId).then((phase) async => {
          if (phase is Phase)
            await ObjectRepository().getObject(objectId).then((object) => {
                  if (object is Object)
                    {
                      loadingStatus = LoadingStatus.completed,
                      notifyListeners(),
                      if (context.mounted)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ObjectPageViewScreenWidget(
                                        object: object,
                                        phase: phase,
                                      )))
                        }
                    }
                })
          else
            loadingStatus = LoadingStatus.error,
          notifyListeners()
        });
  }

  // MARK: -
  // MARK: - PUSH

  void showActionCreateScreen(BuildContext context, Pagination pagination) {
    showCupertinoModalBottomSheet(
        enableDrag: false,
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (sheetContext) => ObjectActionCreateSheetWidget(
            onTap: (text) => {
                  Navigator.pop(context),
                  addObjectTrace(
                    context,
                    pagination,
                    text,
                  )
                }));
  }

  void showTraceScreen(BuildContext context, int index) {
    if (_traces[index].objectId != null) {
      if (_traces[index].phaseId != null) {
        getPhaseById(
            context, _traces[index].objectId!, _traces[index].phaseId!);
      } else {
        getObjectById(context, _traces[index].objectId!);
      }
    } else if (_traces[index].dealId != null) {
      getDealById(context, _traces[index].dealId!);
    } else if (_traces[index].taskId != null) {
      getTaskById(context, _traces[index].taskId!);
    } else if (_traces[index].newsId != null) {
      getNewsById(context, _traces[index].newsId!);
    }
  }
}
