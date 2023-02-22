// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/deal_create/deal_create_screen.dart';
import 'package:izowork/screens/phase/complete_task_screen_body.dart';
import 'package:izowork/screens/phase_create/phase_create_screen.dart';
import 'package:izowork/screens/task_create/task_create_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseViewModel with ChangeNotifier {
  final Phase phase;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseChecklist> _phaseChecklists = [];

  List<PhaseChecklistInformation> _phaseChecklistInformations = [];

  List<PhaseProduct> get phaseProducts {
    return _phaseProducts;
  }

  List<PhaseChecklist> get phaseChecklists {
    return _phaseChecklists;
  }

  List<PhaseChecklistInformation> get phaseChecklistInformations {
    return _phaseChecklistInformations;
  }

  PhaseViewModel(this.phase) {
    getPhaseList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseList() async {
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
                {_phaseChecklists = response}
            })
        .then((value) => getPhaseChecklistInformationList());
  }

  Future getPhaseChecklistInformationList() async {
    await PhaseRepository()
        .getPhaseChecklistInformations(phase.id)
        .then((response) => {
              if (response is List<PhaseChecklistInformation>)
                {
                  _phaseChecklistInformations = response,
                  loadingStatus = LoadingStatus.completed,
                }
            })
        .then((value) => notifyListeners());
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
    _phaseChecklistInformations.forEach((element) {
      if (_phaseChecklists[index].id == element.phaseChecklistId) {
        showCupertinoModalBottomSheet(
            topRadius: const Radius.circular(16.0),
            barrierColor: Colors.black.withOpacity(0.6),
            backgroundColor: HexColors.white,
            context: context,
            builder: (context) => CompleteTaskSheetWidget(
                phaseChecklistInformation: element,
                onTap: (text, files) => {}));
      }
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
            builder: (context) => const PhaseCreateScreenWidget()));
  }
}
