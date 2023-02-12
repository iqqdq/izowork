import 'package:flutter/material.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/search_manager_view_model.dart';
import 'package:izowork/screens/search_manager/search_manager_screen_body.dart';
import 'package:provider/provider.dart';

class SearchManagerScreenWidget extends StatelessWidget {
  final VoidCallback onFocus;
  final Function(User?) onPop;

  const SearchManagerScreenWidget(
      {Key? key, required this.onFocus, required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchManagerViewModel(),
        child: SearchManagerBodyScreenWidget(onFocus: onFocus, onPop: onPop));
  }
}
