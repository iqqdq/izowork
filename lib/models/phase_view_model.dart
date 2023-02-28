// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/phase_checklist_request.dart';
import 'package:izowork/entities/request/phase_checklist_information_file_request.dart';
import 'package:izowork/entities/request/phase_checklist_state_request.dart';
import 'package:izowork/entities/response/error_response.dart';
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

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<File> _files = [];

  int current = 0;

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseContractor> _phaseContractors = [];

  List<PhaseChecklist> _phaseChecklists = [];

  List<PhaseChecklistInformation> _phaseChecklistInformations = [];

  List<File> get files {
    return _files;
  }

  List<PhaseProduct> get phaseProducts {
    return _phaseProducts;
  }

  List<PhaseContractor> get phaseContractors {
    return _phaseContractors;
  }

  List<PhaseChecklist> get phaseChecklists {
    return _phaseChecklists;
  }

  List<PhaseChecklistInformation> get phaseChecklistInformations {
    return _phaseChecklistInformations;
  }

  PhaseViewModel(this.phase) {
    getPhaseContractorList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseContractorList() async {
    await PhaseRepository()
        .getPhaseContractors(phase.id)
        .then((response) => {
              if (response is List<PhaseContractor>)
                {_phaseContractors = response}
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
              if (response is List<PhaseChecklist>)
                {
                  _phaseChecklists = response,
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
            phaseChecklistId: _phaseChecklists[index].id,
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
            id: _phaseChecklists[index].id,
            state: PhaseChecklistState().accepted))
        .then((response) => {
              if (response is PhaseChecklist)
                {
                  loadingStatus = LoadingStatus.completed,
                  _phaseChecklists[index] = response
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка'),
                }
            })
        .then((value) => {Navigator.pop(context), notifyListeners()});
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

  void showDealScreenWidget(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => DealScreenWidget(deal: Deal())));
  }

  void showCompleteTaskScreenSheet(BuildContext context, int index) {
    PhaseChecklistInformation? phaseChecklistInformation;

    getPhaseChecklistInformationList(_phaseChecklists[index].id)
        .then((value) => {
              if (_phaseChecklistInformations.isNotEmpty)
                {phaseChecklistInformation = _phaseChecklistInformations.first},
              showCupertinoModalBottomSheet(
                  topRadius: const Radius.circular(16.0),
                  barrierColor: Colors.black.withOpacity(0.6),
                  backgroundColor: HexColors.white,
                  context: context,
                  builder: (context) => CompleteChecklistScreenWidget(
                      title: _phaseChecklists[index].name,
                      phaseChecklistInformation: phaseChecklistInformation,
                      onTap: (text, files) => {
                            files.forEach((element) {
                              if (element.path != null) {
                                _files.add(File(element.path!));
                              }
                            }),
                            createPhaseChecklistInfo(context, index, text)
                          }))
            });
  }

  void showDealCreateScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DealCreateScreenWidget()));
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
                  phaseChecklists: _phaseChecklists,
                  onPop: ((phaseProducts, phaseContractors, phaseChecklists) =>
                      {
                        _phaseProducts = phaseProducts,
                        _phaseContractors = phaseContractors,
                        _phaseChecklists = phaseChecklists,
                        notifyListeners()
                      }),
                )));
  }
}
