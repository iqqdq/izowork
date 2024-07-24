import 'package:flutter/material.dart';
import 'package:izowork/features/search_object/view_model/search_object_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/search_object/view/search_object_screen_body.dart';
import 'package:provider/provider.dart';

class SearchObjectScreenWidget extends StatelessWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(MapObject?) onPop;

  const SearchObjectScreenWidget({
    Key? key,
    required this.title,
    required this.isRoot,
    required this.onFocus,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchObjectViewModel(),
        child: SearchObjectScreenBodyWidget(
          title: title,
          isRoot: isRoot,
          onFocus: onFocus,
          onPop: onPop,
        ));
  }
}
