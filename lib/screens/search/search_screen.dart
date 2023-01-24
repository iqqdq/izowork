import 'package:flutter/material.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/search/search_screen_body.dart';
import 'package:provider/provider.dart';

class SearchScreenWidget extends StatelessWidget {
  final bool isRoot;
  final SearchType searchType;
  final VoidCallback onPop;

  const SearchScreenWidget(
      {Key? key,
      required this.isRoot,
      required this.searchType,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchViewModel(searchType),
        child: SearchBodyScreenWidget(isRoot: isRoot, onPop: onPop));
  }
}
