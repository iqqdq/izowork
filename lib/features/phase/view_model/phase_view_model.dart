// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class PhaseViewModel with ChangeNotifier {
  final String id;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  bool _isDirector = false;

  Phase? _phase;

  final List<Deal> _deals = [];

  List<PhaseProduct> _phaseProducts = [];

  List<PhaseContractor> _phaseContractors = [];

  PhaseChecklistResponse? _phaseChecklistResponse;

  String? _error;

  bool get isDirector => _isDirector;

  Phase? get phase => _phase;

  List<Deal> get deals => _deals;

  List<PhaseProduct> get phaseProducts => _phaseProducts;

  List<PhaseContractor> get phaseContractors => _phaseContractors;

  PhaseChecklistResponse? get phaseChecklistResponse => _phaseChecklistResponse;

  String? get error => _error;

  PhaseViewModel(this.id) {
    _checkIsDirector().whenComplete(() => getPhaseById());
  }

  Future _checkIsDirector() async {
    User? user = await sl<LocalStorageRepositoryInterface>().getUser();
    if (user == null) return;
    if (user.roles == null) return;

    for (var role in user.roles!) {
      if (role.name.toLowerCase().contains('директор')) _isDirector = true;
      if (_isDirector == true) break;
    }
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseById() async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
        .getPhase(id)
        .then((phase) async => {
              if (phase is Phase) _phase = phase,
            })
        .then((value) => getPhaseContractorList());
  }

  Future getPhaseContractorList() async {
    await sl<PhaseRepositoryInterface>()
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
    await sl<PhaseRepositoryInterface>()
        .getPhaseProducts(id)
        .then((response) => {
              if (response is List<PhaseProduct>) _phaseProducts = response,
            })
        .then(
          (value) => getPhaseDealList(),
        );
  }

  Future getPhaseDealList() async {
    await sl<PhaseRepositoryInterface>()
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
    await sl<PhaseRepositoryInterface>()
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

    await sl<PhaseRepositoryInterface>()
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

  Future updateChecklistState(
    int index,
    String state,
  ) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    await sl<PhaseRepositoryInterface>()
        .updatePhaseChecklistState(PhaseChecklistStateRequest(
          id: _phaseChecklistResponse?.phaseChecklists[index].id ?? '',
          state: state,
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

  // void updateDeals(Deal deal) {
  //   _deals.add(deal);
  //   notifyListeners();
  // }

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
