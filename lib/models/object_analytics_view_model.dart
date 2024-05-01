// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/components/toast.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/repositories/phase_repository.dart';
import 'package:izowork/services/urls.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class ObjectAnalyticsViewModel with ChangeNotifier {
  final Object object;
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

  Future openFile(BuildContext context, int index) async {
    String url = objectMediaUrl + (object.files[index].filename ?? '');

    if (Platform.isAndroid) {
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;
      String fileName = object.files[index].name;
      String filePath = '$appDocumentsPath/$fileName';
      bool isFileExists = await io.File(filePath).exists();

      if (!isFileExists) {
        _downloadIndex = index;
        notifyListeners();

        await Dio().download(url, filePath, onReceiveProgress: (count, total) {
          debugPrint('---Download----Rec: $count, Total: $total');
        }).whenComplete(() => {
              _downloadIndex = -1,
              notifyListeners(),
            });
      }

      OpenResult openResult = await OpenFilex.open(filePath);

      if (openResult.type == ResultType.noAppToOpen) {
        Toast().showTopToast(context, Titles.unsupportedFileFormat);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse(url.replaceAll(' ', '')));
      } else if (await canLaunchUrl(
          Uri.parse('https://' + url.replaceAll(' ', '')))) {
        launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
      }
    }
  }
}
