import 'package:flutter/material.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/search_user_view_model.dart';
import 'package:izowork/screens/search_user/search_user_screen_body.dart';
import 'package:provider/provider.dart';

class SearchUserScreenWidget extends StatelessWidget {
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(User?) onPop;

  const SearchUserScreenWidget(
      {Key? key,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchUserViewModel(),
        child: SearchUserScreenBodyWidget(
            isRoot: isRoot, onFocus: onFocus, onPop: onPop));
  }
}
