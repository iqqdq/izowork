// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  Phase? _phase;

  final List<File> _files = [];

  final List<Deal> _deals = [];

  int _current = 0;

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseContractor> _phaseContractors = [];

  PhaseChecklistResponse? _phaseChecklistResponse;

  List<PhaseChecklistInfo> _phaseChecklistInfos = [];

  String? _error;

  Phase? get phase => _phase;

  List<File> get files => _files;

  List<Deal> get deals => _deals;

  List<PhaseProduct> get phaseProducts => _phaseProducts;

  List<PhaseContractor> get phaseContractors => _phaseContractors;

  PhaseChecklistResponse? get phaseChecklistResponse => _phaseChecklistResponse;

  List<PhaseChecklistInfo> get phaseChecklistInfos => _phaseChecklistInfos;

  String? get error => _error;

  PhaseViewModel(this.id) {
    getPhaseById();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseById() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await PhaseRepository()
        .getPhase(id)
        .then((phase) async => {
              if (phase is Phase) _phase = phase,
            })
        .then((value) => getPhaseContractorList());
  }

  Future getPhaseContractorList() async {
    await PhaseRepository()
        .getPhaseContractors(id)
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
        .getPhaseProducts(id)
        .then((response) => {
              if (response is List<PhaseProduct>) _phaseProducts = response,
            })
        .then(
          (value) => getPhaseDealList(),
        );
  }

  Future getPhaseDealList() async {
    await PhaseRepository()
        .getPhaseDeals(id)
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
        .getPhaseChecklistList(id)
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
                        await uploadFile(
                          response.id,
                          element,
                        ).then((value) => {
                              _current++,
                              if (_current == _files.length)
                                updateChecklistState(index),
                            });
                      })
                    }
                  else
                    updateChecklistState(index),
                }
            });
  }

  Future updateChecklistState(int index) async {
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
            })
        .whenComplete(() => notifyListeners());
  }

  Future uploadFile(
    String id,
    File file,
  ) async =>
      await PhaseRepository()
          .addPhaseChecklistInfoFile(PhaseChecklistInfoFileRequest(id, file));

  void updateDeals(Deal deal) {
    _deals.add(deal);
    notifyListeners();
  }

  void updatePhaseParams(
    List<PhaseProduct> newPhaseProducts,
    List<PhaseContractor> newPhaseContractors,
    List<PhaseChecklist> newPhaseChecklists,
  ) {
    _phaseProducts = newPhaseProducts;
    _phaseContractors = newPhaseContractors;
    _phaseChecklistResponse?.phaseChecklists = newPhaseChecklists;

    notifyListeners();
  }
}
