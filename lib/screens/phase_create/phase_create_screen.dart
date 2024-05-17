import 'package:flutter/material.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/phase_create/phase_create_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseCreateScreenWidget extends StatelessWidget {
  final Phase phase;
  final List<PhaseProduct> phaseProducts;
  final List<PhaseContractor> phaseContractors;
  final List<PhaseChecklist> phaseChecklists;
  final Function(
      List<PhaseProduct>, List<PhaseContractor>, List<PhaseChecklist>) onPop;

  const PhaseCreateScreenWidget({
    Key? key,
    required this.phase,
    required this.phaseProducts,
    required this.phaseContractors,
    required this.phaseChecklists,
    required this.onPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseCreateViewModel(
              phase,
              phaseProducts,
              phaseContractors,
              phaseChecklists,
            ),
        child: PhaseCreateScreenBodyWidget(onPop: onPop));
  }
}
