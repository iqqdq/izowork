import 'package:flutter/material.dart';
import 'package:izowork/entities/phase.dart';
import 'package:izowork/models/phase_create_view_model.dart';
import 'package:izowork/screens/phase_create/phase_create_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseCreateScreenWidget extends StatelessWidget {
  final Phase? phase;

  const PhaseCreateScreenWidget({Key? key, this.phase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseCreateViewModel(phase),
        child: PhaseCreateScreenBodyWidget(phase: phase));
  }
}
