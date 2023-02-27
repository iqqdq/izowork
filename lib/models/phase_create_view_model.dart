// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/request/checklist_request.dart';
import 'package:izowork/entities/request/delete_request.dart';
import 'package:izowork/entities/request/phase_checklist_information_file_request.dart';
import 'package:izowork/entities/request/phase_contractor_request.dart';
import 'package:izowork/entities/request/phase_contractor_update_request.dart';
import 'package:izowork/entities/request/phase_product_request.dart';
import 'package:izowork/entities/request/phase_product_update_request.dart';
import 'package:izowork/entities/response/error_response.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_checklist_information.dart';
import 'package:izowork/entities/response/phase_contractor.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/screens/complete_checklist/complete_checklist_screen.dart';
import 'package:izowork/screens/product_type_selection/product_type_selection_screen.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PhaseCreateViewModel with ChangeNotifier {
  // INIT
  final Phase phase;
  final List<PhaseProduct> phaseProducts;
  final List<PhaseContractor> phaseContractors;
  final List<PhaseChecklist> phaseChecklists;

  final List<File> _files = [];

  int current = 0;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  List<PhaseChecklistInformation> _phaseChecklistInformations = [];

  List<File> get files {
    return _files;
  }

  List<PhaseChecklistInformation> get phaseChecklistInformations {
    return _phaseChecklistInformations;
  }

  PhaseCreateViewModel(this.phase, this.phaseProducts, this.phaseContractors,
      this.phaseChecklists);

  // MARK: -
  // MARK: - API CALL

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
            phaseChecklistId: phaseChecklists[index].id,
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
                                    {
                                      loadingStatus = LoadingStatus.completed,
                                      notifyListeners(),
                                      Navigator.pop(context)
                                    }
                                });
                      })
                    }
                  else
                    {
                      loadingStatus = LoadingStatus.completed,
                      notifyListeners(),
                      Navigator.pop(context)
                    }
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  notifyListeners(),
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                }
            });
  }

  Future createContractor(BuildContext context, int? index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseContractor(PhaseContractorRequest(
            phaseId: phase.id,
            coExecutorId:
                index == null ? null : phaseContractors[index].coExecutorId,
            contractorId:
                index == null ? null : phaseContractors[index].contractorId,
            observerId:
                index == null ? null : phaseContractors[index].observerId,
            responsibleId:
                index == null ? null : phaseContractors[index].responsibleId))
        .then((response) => {
              if (response is PhaseContractor)
                {
                  loadingStatus = LoadingStatus.completed,
                  phaseContractors.add(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future updateContractor(BuildContext context, int index) async {
    await PhaseRepository()
        .updatePhaseContractor(PhaseContractorUpdateRequest(
            id: phaseContractors[index].id,
            coExecutorId: phaseContractors[index].coExecutorId,
            contractorId: phaseContractors[index].contractorId,
            observerId: phaseContractors[index].observerId,
            responsibleId: phaseContractors[index].responsibleId))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future deleteContractor(BuildContext context, int index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .deletePhaseContractor(DeleteRequest(id: phaseContractors[index].id))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  phaseContractors.removeAt(index)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future createProduct(BuildContext context) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .createPhaseProduct(PhaseProductRequest(phaseId: phase.id))
        .then((response) => {
              if (response is PhaseProduct)
                {
                  loadingStatus = LoadingStatus.completed,
                  phaseProducts.add(response)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future updateProduct(BuildContext context, int index) async {
    await PhaseRepository()
        .updatePhaseProduct(PhaseProductUpdateRequest(
            id: phaseProducts[index].id,
            phaseId: phase.id,
            count: phaseProducts[index].count,
            productId: phaseProducts[index].productId,
            termInDays: phaseProducts[index].termInDays))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
  }

  Future deletePhaseProduct(BuildContext context, int index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .deletePhaseProduct(DeleteRequest(id: phaseProducts[index].id))
        .then((response) => {
              if (response == true)
                {
                  loadingStatus = LoadingStatus.completed,
                  phaseProducts.removeAt(index)
                }
              else if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(context, response.message ?? 'Ошибка')
                },
              notifyListeners()
            });
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
  // MARK: - ACTIONS

  void changeProductTermInDays(BuildContext context, int index, int days) {
    phaseProducts[index].termInDays = days;
    updateProduct(context, index);
  }

  void changeProductCount(BuildContext context, int index, int count) {
    phaseProducts[index].count = count;
    updateProduct(context, index);
  }

  // MARK: -
  // MARK: - PUSH

  void changeContractor(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchCompanyScreenWidget(
            title: Titles.contractor,
            isRoot: true,
            onFocus: () => {},
            onPop: (company) => {
                  Navigator.pop(context),
                  phaseContractors[index].contractor = company,
                  phaseContractors[index].contractorId = company?.id,
                  updateContractor(context, index)
                }));
  }

  void changeContractorResponsible(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchUserScreenWidget(
            title: Titles.responsible,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
                  Navigator.pop(context),
                  phaseContractors[index].responsible = user,
                  phaseContractors[index].responsibleId = user?.id,
                  updateContractor(context, index)
                }));
  }

  void changeContractorCoExecutor(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchUserScreenWidget(
            title: Titles.coExecutor,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
                  Navigator.pop(context),
                  phaseContractors[index].coExecutor = user,
                  phaseContractors[index].coExecutorId = user?.id,
                  updateContractor(context, index)
                }));
  }

  void changeContractorObserver(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => SearchUserScreenWidget(
            title: Titles.observer,
            isRoot: true,
            onFocus: () => {},
            onPop: (user) => {
                  Navigator.pop(context),
                  phaseContractors[index].observer = user,
                  phaseContractors[index].observerId = user?.id,
                  updateContractor(context, index)
                }));
  }

  void showCompleteTaskScreenSheet(BuildContext context, int index) {
    PhaseChecklistInformation? phaseChecklistInformation;

    getPhaseChecklistInformationList(phaseChecklists[index].id)
        .then((value) => {
              if (_phaseChecklistInformations.isNotEmpty)
                {phaseChecklistInformation = _phaseChecklistInformations.first},
              showCupertinoModalBottomSheet(
                  topRadius: const Radius.circular(16.0),
                  barrierColor: Colors.black.withOpacity(0.6),
                  backgroundColor: HexColors.white,
                  context: context,
                  builder: (context) => CompleteChecklistScreenWidget(
                      title: phaseChecklists[index].name,
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

  void showProductSearchScreenSheet(BuildContext context, int index) {
    showCupertinoModalBottomSheet(
        topRadius: const Radius.circular(16.0),
        barrierColor: Colors.black.withOpacity(0.6),
        backgroundColor: HexColors.white,
        context: context,
        builder: (context) => ProductTypeSelectionScreenWidget(
            isRoot: true,
            title: Titles.product,
            // productType: phaseProducts[index].product,
            onSelect: (productType) => {
                  if (productType != null)
                    {
                      Navigator.pop(context),
                      phaseProducts[index].productId = productType.id,
                      updateProduct(context, index)
                    }
                }));
  }

  void showTaskCreateScreen(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => const TaskCreateScreenWidget()));
  }
}
