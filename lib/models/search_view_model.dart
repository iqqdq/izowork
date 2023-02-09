import 'package:flutter/material.dart';
import 'package:izowork/components/loading_status.dart';

enum SearchType {
  employee,
  responsible,
  manager,
  developer,
  contractor,
  company,
  object,
  type,
  filial,
  product,
  phase
}

class SearchViewModel with ChangeNotifier {
  // INIT
  final SearchType searchType;

  // LoadingStatus loadingStatus = LoadingStatus.searching;
  LoadingStatus loadingStatus = LoadingStatus.empty;

  SearchViewModel(this.searchType);

  // MARK: -
  // MARK: - FUNCTIONS

  // MARK: -
  // MARK: - PUSH
}
