// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/entities/requests/requests.dart';
import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/phase_checklist_complete/phase_checklist_complete_screen.dart';
import 'package:izowork/screens/phase_create/phase_create_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseViewModel with ChangeNotifier {
  final Phase phase;
  final Object? object;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<File> _files = [];

  final List<Deal> _deals = [];

  int _current = 0;

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseContractor> _phaseContractors = [];

  PhaseChecklistResponse? _phaseChecklistResponse;

  List<PhaseChecklistInfo> _phaseChecklistInfos = [];

  String? _error;

  List<File> get files => _files;

  List<Deal> get deals => _deals;

  List<PhaseProduct> get phaseProducts => _phaseProducts;

  List<PhaseContractor> get phaseContractors => _phaseContractors;

  PhaseChecklistResponse? get phaseChecklistResponse => _phaseChecklistResponse;

  List<PhaseChecklistInfo> get phaseChecklistInfos => _phaseChecklistInfos;

  String? get error => _error;

  PhaseViewModel(
    this.phase,
    this.object,
  ) {
    getPhaseContractorList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseContractorList() async {
    await PhaseRepository()
        .getPhaseContractors(phase.id)
        .then((response) => {
              if (response is List<PhaseContractor>)
                _phaseContractors = response
            })
        .then(
          (value) => getPhaseProductList(),
        );
  }

  Future getPhaseProductList() async {
    await PhaseRepository()
        .getPhaseProducts(phase.id)
        .then((response) => {
              if (response is List<PhaseProduct>) _phaseProducts = response,
            })
        .then(
          (value) => getPhaseDealList(),
        );
  }

  Future getPhaseDealList() async {
    await PhaseRepository()
        .getPhaseDeals(phase.id)
        .then((response) => {
              if (response is List<Deal>)
                {
                  for (var element in response)
                    {
                      _deals.add(element),
                    },
                },
            })
        .then((value) => getPhaseChecklistList());
  }

  Future getPhaseChecklistList() async {
    await PhaseRepository()
        .getPhaseChecklistList(phase.id)
        .then((response) => {
              if (response is PhaseChecklistResponse)
                {
                  _phaseChecklistResponse = response,
                  loadingStatus = LoadingStatus.completed
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future removePhaseChecklist(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .deletePhaseChecklist(DeleteRequest(id: id))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistResponse?.phaseChecklists
                      .removeWhere((element) => element.id == id),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  _error = response.message,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future getPhaseChecklistInfoList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .getPhaseChecklistInfoList(id)
        .then((response) => {
              if (response is List<PhaseChecklistInfo>)
                {
                  _phaseChecklistInfos = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .whenComplete(() => notifyListeners());
  }

  Future createPhaseChecklistInfo(
    BuildContext context,
    int index,
    String description,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklistInfo(PhaseChecklistInfoRequest(
          phaseChecklistId:
              _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
          description: description,
        ))
        .then((response) => {
              if (response is PhaseChecklistInfo)
                {
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        await uploadFile(context, response.id, element)
                            .then((value) => {
                                  _current++,
                                  if (_current == _files.length)
                                    updateChecklistState(
                                      context,
                                      index,
                                    ),
                                });
                      })
                    }
                  else
                    updateChecklistState(
                      context,
                      index,
                    ),
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(
                    context,
                    response.message ?? 'Ошибка',
                  )
                }
            });
  }

  Future updateChecklistState(
    BuildContext context,
    int index,
  ) async {
    await PhaseRepository()
        .updatePhaseChecklistState(PhaseChecklistStateRequest(
          id: _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
          state: PhaseChecklistState.underReview,
        ))
        .then((response) => {
              if (response is PhaseChecklist)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistResponse?.phaseChecklists[index] = response
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(
                    context,
                    response.message ?? 'Ошибка',
                  ),
                }
            })
        .then(
          (value) => notifyListeners(),
        );
  }

  Future uploadFile(
    BuildContext context,
    String id,
    File file,
  ) async {
    await PhaseRepository()
        .addPhaseChecklistInfoFile(PhaseChecklistInfoFileRequest(
          id,
          file,
        ))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(
                    context,
                    response.message ?? 'Ошибка',
                  )
                }
            });
  }

  // MARK: -
  // MARK: - PUSH

  // void showDealScreenWidget(BuildContext context) {
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => DealScreenWidget(deal: Deal())));
  // }

  void showCompleteTaskSheet(
    BuildContext context,
    int index,
  ) async {
    PhaseChecklistInfo? phaseChecklistInfo;

    await getPhaseChecklistInfoList(
      _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
    ).then((value) => {
          if (_phaseChecklistInfos.isNotEmpty)
            phaseChecklistInfo = _phaseChecklistInfos.first,

          // SHOW CHECKLIST SHEET

          if (_phaseChecklistResponse != null)
            {
              if (_phaseChecklistResponse!.canEdit)
                showCupertinoModalBottomSheet(
                    enableDrag: false,
                    topRadius: const Radius.circular(16.0),
                    barrierColor: Colors.black.withOpacity(0.6),
                    backgroundColor: HexColors.white,
                    context: context,
                    builder: (sheetContext) =>
                        PhaseChecklistCompleteScreenWidget(
                            title: _phaseChecklistResponse
                                    ?.phaseChecklists[index].name ??
                                '',
                            phaseChecklistInfo: phaseChecklistInfo,
                            onTap: (
                              text,
                              files,
                            ) =>
                                {
                                  // HIDE BOTTOM SHEET
                                  Navigator.pop(context),

                                  // SET SELECTED FILES
                                  files.forEach((element) {
                                    if (element.path != null) {
                                      _files.add(File(element.path!));
                                    }
                                  }),

                                  // CREATE NEW PHASE CHECKLIST
                                  createPhaseChecklistInfo(
                                    context,
                                    index,
                                    text,
                                  )
                                }))
              else
                Toast().showTopToast(
                  context,
                  Titles.youHaveNotPermissionToFillChecklist,
                )
            }
        });
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealCreateScreenWidget(
                phase: phase,
                object: object,
                onCreate: (deal, dealProducts) => {
                      if (deal != null)
                        {
                          _deals.add(deal),
                          notifyListeners(),
                          Toast().showTopToast(context,
                              '${Titles.deal} №${deal.number} добавлена')
                        }
                    })));
  }

  void showTaskCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TaskCreateScreenWidget(
                onCreate: (task) => {
                      // TODO: -
                    })));
  }

  void showPhaseCreateScreen(
    BuildContext context,
    VoidCallback onUpdate,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhaseCreateScreenWidget(
                  phase: phase,
                  phaseProducts: _phaseProducts,
                  phaseContractors: _phaseContractors,
                  phaseChecklists:
                      _phaseChecklistResponse?.phaseChecklists ?? [],
                  onPop: ((
                    newPhaseProducts,
                    newPhaseContractors,
                    newPhaseChecklists,
                  ) =>
                      {
                        _phaseProducts = newPhaseProducts,
                        _phaseContractors = newPhaseContractors,
                        _phaseChecklistResponse?.phaseChecklists =
                            newPhaseChecklists,

                        /// UPDATE UI
                        onUpdate(),
                      }),
                )));
  }

  void showDealScreenWidget(
    BuildContext context,
    int index,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DealScreenWidget(deal: deals[index])));
  }
}
