import 'package:flutter/material.dart';
import 'package:izowork/features/selection/view_model/selection_view_model.dart';

import 'package:izowork/features/selection/view/selection_screen_body.dart';
import 'package:provider/provider.dart';

class SelectionScreenWidget extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final Function(String) onSelectTap;

  const SelectionScreenWidget(
      {Key? key,
      required this.title,
      required this.value,
      required this.items,
      required this.onSelectTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SelectionViewModel(items),
        child: SelectionScreenBodyWidget(
          title: title,
          value: value,
          onSelectTap: onSelectTap,
        ));
  }
}
