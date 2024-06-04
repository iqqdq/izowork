// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/helpers/helpers.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/api/api.dart';

class ObjectAnalyticsViewModel with ChangeNotifier {
  final MapObject object;
  final List<Phase> phases;

  LoadingStatus loadingStatus = LoadingStatus.searching;

  final List<List<PhaseProduct>> _phaseProductList = [];

  int _downloadIndex = -1;

  List<List<PhaseProduct>> get phaseProductList => _phaseProductList;

  int get downloadIndex => _downloadIndex;

  ObjectAnalyticsViewModel(this.object, this.phases) {
    getPhaseProductList();
  }

  // MARK: -
  // MARK: - API CALL

  Future getPhaseProductList() async {
    int index = 0;
    phases.forEach((element) async {
      await PhaseRepository()
          .getPhaseProducts(element.id)
          .then((response) => {
                if (response is List<PhaseProduct>)
                  {_phaseProductList.add(response)}
              })
          .then((value) => {
                if (index == phases.length - 1)
                  {
                    loadingStatus = LoadingStatus.completed,
                    notifyListeners(),
                  }
                else
                  index++
              });
    });
  }

  // MARK: -
  // MARK: - ACTIONS

  Future openFile(int index) async {
    final filename = object.files[index].filename;
    if (filename == null) return;

    FileDownloadHelper().download(
        url: objectMediaUrl + filename,
        filename: filename,
        onDownload: () => {
              _downloadIndex = index,
              notifyListeners(),
            },
        onComplete: () => {
              _downloadIndex = -1,
              notifyListeners(),
            });
  }
}
