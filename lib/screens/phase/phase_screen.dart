import 'package:flutter/material.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/models/phase_view_model.dart';
import 'package:izowork/screens/phase/phase_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseScreenWidget extends StatelessWidget {
  final Phase phase;
  final Object? object;

  const PhaseScreenWidget({Key? key, required this.phase, this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseViewModel(phase, object),
        child: PhaseCreateScreenBodyWidget(phase: phase));
  }
}
