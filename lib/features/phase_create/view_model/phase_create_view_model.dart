// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseCreateViewModel with ChangeNotifier {
  final Phase phase;
  final List<PhaseProduct> phaseProducts;
  final List<PhaseContractor> phaseContractors;
  final List<PhaseChecklist> phaseChecklists;

  final List<File> _files = [];

  int current = 0;

  LoadingStatus loadingStatus = LoadingStatus.empty;

  List<File> get files => _files;

  PhaseCreateViewModel(
    this.phase,
    this.phaseProducts,
    this.phaseContractors,
    this.phaseChecklists,
  );

  // MARK: -
  // MARK: - API CALL

  Future createContractor(int? index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
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
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateContractor(int index) async {
    await sl<PhaseRepositoryInterface>()
        .updatePhaseContractor(PhaseContractorUpdateRequest(
          id: phaseContractors[index].id,
          coExecutorId: phaseContractors[index].coExecutorId,
          contractorId: phaseContractors[index].contractorId,
          observerId: phaseContractors[index].observerId,
          responsibleId: phaseContractors[index].responsibleId,
        ))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future deleteContractor(int index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
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
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future createProduct() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
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
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future updateProduct(int index) async {
    await sl<PhaseRepositoryInterface>()
        .updatePhaseProduct(PhaseProductUpdateRequest(
          id: phaseProducts[index].id,
          phaseId: phase.id,
          count: phaseProducts[index].count,
          productId: phaseProducts[index].productId,
          termInDays: phaseProducts[index].termInDays,
        ))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
              notifyListeners()
            })
        .whenComplete(() => notifyListeners());
  }

  Future deletePhaseProduct(int index) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
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
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                },
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    String id,
    File file,
  ) async {
    await sl<PhaseRepositoryInterface>()
        .addPhaseChecklistInfoFile(PhaseChecklistInfoFileRequest(
          id,
          file,
        ))
        .then((response) => {
              if (response is ErrorResponse)
                {
                  loadingStatus = LoadingStatus.error,
                  Toast().showTopToast(response.message ?? 'Произошла ошибка')
                }
            });
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void changeContracor(
    Company? company,
    int index,
  ) {
    if (company == null) return;
    phaseContractors[index].contractor = company;
    phaseContractors[index].contractorId = company.id;

    updateContractor(index);
  }

  void changeResponsible(
    User? user,
    int index,
  ) {
    if (user == null) return;
    phaseContractors[index].responsible = user;
    phaseContractors[index].responsibleId = user.id;

    updateContractor(index);
  }

  void changeCoExecutor(
    User? user,
    int index,
  ) {
    if (user == null) return;
    phaseContractors[index].coExecutor = user;
    phaseContractors[index].coExecutorId = user.id;

    updateContractor(index);
  }

  void changeObserver(
    User? user,
    int index,
  ) {
    if (user == null) return;
    phaseContractors[index].observer = user;
    phaseContractors[index].observerId = user.id;

    updateContractor(index);
  }

  void changeProduct(
    Product? product,
    int index,
  ) {
    if (product == null) return;
    phaseProducts[index].productId = product.id;
    phaseProducts[index].product = product;

    updateProduct(index);
  }

  void changeProductTermInDays(
    int index,
    int days,
  ) {
    phaseProducts[index].termInDays = days;

    updateProduct(index);
  }

  void changeProductCount(
    int index,
    int count,
  ) {
    phaseProducts[index].count = count;

    updateProduct(index);
  }
}
