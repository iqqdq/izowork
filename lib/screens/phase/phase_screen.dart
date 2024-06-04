import 'package:flutter/material.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/phase/phase_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseScreenWidget extends StatelessWidget {
  final String id;

  const PhaseScreenWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseViewModel(id),
        child: const PhaseScreenBodyWidget());
  }
}
