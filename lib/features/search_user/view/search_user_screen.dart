import 'package:flutter/material.dart';
import 'package:izowork/features/search_user/view_model/search_user_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/search_user/view/search_user_screen_body.dart';
import 'package:provider/provider.dart';

class SearchUserScreenWidget extends StatelessWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(User?) onPop;

  const SearchUserScreenWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchUserViewModel(),
        child: SearchUserScreenBodyWidget(
            title: title, isRoot: isRoot, onFocus: onFocus, onPop: onPop));
  }
}
