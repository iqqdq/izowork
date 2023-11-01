// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/phase_checklist_request.dart';
import 'package:izowork/entities/request/phase_checklist_information_file_request.dart';
import 'package:izowork/entities/request/phase_checklist_state_request.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/entities/response/phase_contractor.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/complete_checklist/complete_checklist_screen.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/phase_create/phase_create_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseViewModel with ChangeNotifier {
  final Phase phase;
  final Object? object;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<File> _files = [];

  final List<Deal> _deals = [];

  int current = 0;

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseContractor> _phaseContractors = [];

  PhaseChecklistResponse? _phaseChecklistResponse;

  List<PhaseChecklistInformation> _phaseChecklistInformations = [];

  List<File> get files {
    return _files;
  }

  List<Deal> get deals {
    return _deals;
  }

  List<PhaseProduct> get phaseProducts {
    return _phaseProducts;
  }

  List<PhaseContractor> get phaseContractors {
    return _phaseContractors;
  }

  PhaseChecklistResponse? get phaseChecklistResponse {
    return _phaseChecklistResponse;
  }

  List<PhaseChecklistInformation> get phaseChecklistInformations {
    return _phaseChecklistInformations;
  }

  PhaseViewModel(this.phase, this.object) {
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
        .then((value) => getPhaseProductList());
  }

  Future getPhaseProductList() async {
    await PhaseRepository()
        .getPhaseProducts(phase.id)
        .then((response) => {
              if (response is List<PhaseProduct>) {_phaseProducts = response}
            })
        .then((value) => getPhaseChecklistList());
  }

  Future getPhaseChecklistList() async {
    await PhaseRepository()
        .getPhaseChecklists(phase.id)
        .then((response) => {
              if (response is PhaseChecklistResponse)
                {
                  _phaseChecklistResponse = response,
                  loadingStatus = LoadingStatus.completed
                }
            })
        .then((value) => notifyListeners());
  }

  Future getPhaseChecklistInformationList(String id) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .getPhaseChecklistInformations(id)
        .then((response) => {
              if (response is List<PhaseChecklistInformation>)
                {
                  _phaseChecklistInformations = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .then((value) => notifyListeners());
  }

  Future createPhaseChecklistInfo(
      BuildContext context, int index, String description) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseChecklistInformation(PhaseChecklistInformationRequest(
            phaseChecklistId:
                _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
            description: description))
        .then((response) => {
              if (response is PhaseChecklistInformation)
                {
                  if (_files.isNotEmpty)
                    {
                      _files.forEach((element) async {
                        await uploadFile(context, response.id, element)
                            .then((value) => {
                                  current++,
                                  if (current == _files.length)
                                    {updateChecklistState(context, index)}
                                });
                      })
                    }
                  else
                    {updateChecklistState(context, index)}
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            });
  }

  Future updateChecklistState(BuildContext context, int index) async {
    await PhaseRepository()
        .updatePhaseChecklistState(PhaseChecklistStateRequest(
            id: _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
            state: PhaseChecklistState.underReview))
        .then((response) => {
              if (response is PhaseChecklist)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklistResponse?.phaseChecklists[index] = response
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка'),
                }
            })
        .then((value) => notifyListeners());
  }

  Future uploadFile(BuildContext context, String id, File file) async {
    await PhaseRepository()
        .addPhaseChecklistInformationFile(
            PhaseChecklistInformationFileRequest(id, file))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
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
    bool canEdit,
  ) {
    PhaseChecklistInformation? phaseChecklistInformation;

    getPhaseChecklistInformationList(
      _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
    ).then((value) => {
          if (_phaseChecklistInformations.isNotEmpty)
            {
              phaseChecklistInformation = _phaseChecklistInformations.first,
            },
          if (phaseChecklistInformation == null && !canEdit)
            {}
          else
            {
              showCupertinoModalBottomSheet(
                  enableDrag: false,
                  topRadius: const Radius.circular(16.0),
                  barrierColor: Colors.black.withOpacity(0.6),
                  backgroundColor: HexColors.white,
                  context: context,
                  builder: (context) => CompleteChecklistScreenWidget(
                      title: _phaseChecklistResponse
                              ?.phaseChecklists[index].name ??
                          '',
                      phaseChecklistInformation: phaseChecklistInformation,
                      onTap: (text, files) => {
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
                      // TODO
                    })));
  }

  void showPhaseCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhaseCreateScreenWidget(
                  phase: phase,
                  phaseProducts: _phaseProducts,
                  phaseContractors: _phaseContractors,
                  phaseChecklists:
                      _phaseChecklistResponse?.phaseChecklists ?? [],
                  onPop: ((phaseProducts, phaseContractors, phaseChecklists) =>
                      {
                        _phaseProducts = phaseProducts,
                        _phaseContractors = phaseContractors,
                        _phaseChecklistResponse?.phaseChecklists =
                            phaseChecklists,
                        notifyListeners()
                      }),
                )));
  }
}
