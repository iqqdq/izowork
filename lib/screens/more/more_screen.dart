import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/more/more_screen_body.dart';
import 'package:provider/provider.dart';

class MoreScreenWidget extends StatelessWidget {
  final int count;

  const MoreScreenWidget({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MoreViewModel(count),
        child: const MoreScreenBodyWidget());
  }
}
