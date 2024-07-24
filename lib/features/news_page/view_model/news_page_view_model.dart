// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';

class NewsPageViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  final String id;

  News? _news;

  News? get news => _news;

  NewsPageViewModel(this.id) {
    getNewsById(id: id);
  }

  // MARK: -
  // MARK: - API CALL

  Future getNewsById({required String id}) async {
    await sl<NewsRepositoryInterface>()
        .getNewsOne(id)
        .then((response) => {
              if (response is News)
                {
                  loadingStatus = LoadingStatus.completed,
                  _news = response,
                }
              else
                loadingStatus = LoadingStatus.error,
            })
        .whenComplete(() => notifyListeners());
  }
}
