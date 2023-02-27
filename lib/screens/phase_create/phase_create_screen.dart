import 'package:flutter/material.dart';
import 'package:izowork/entities/response/phase.dart';
import 'package:izowork/entities/response/phase_checklist.dart';
import 'package:izowork/entities/response/phase_contractor.dart';
import 'package:izowork/entities/response/phase_product.dart';
import 'package:izowork/models/phase_create_view_model.dart';
import 'package:izowork/screens/phase_create/phase_create_screen_body.dart';
import 'package:provider/provider.dart';

class PhaseCreateScreenWidget extends StatelessWidget {
  final Phase phase;
  final List<PhaseProduct> phaseProducts;
  final List<PhaseContractor> phaseContractors;
  final List<PhaseChecklist> phaseChecklists;
  final Function(
      List<PhaseProduct>, List<PhaseContractor>, List<PhaseChecklist>) onPop;

  const PhaseCreateScreenWidget(
      {Key? key,
      required this.phase,
      required this.phaseProducts,
      required this.phaseContractors,
      required this.phaseChecklists,
      required this.onPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhaseCreateViewModel(
            phase, phaseProducts, phaseContractors, phaseChecklists),
        child: PhaseCreateScreenBodyWidget(onPop: onPop));
  }
}
