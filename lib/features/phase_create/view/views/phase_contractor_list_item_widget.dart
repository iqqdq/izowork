import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/features/analytics/view/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';

class PhaseContractorListItemWidget extends StatefulWidget {
  final int index;
  final PhaseContractor? phaseContractor;
  final VoidCallback onDeleteTap;
  final VoidCallback onContractorTap;
  final VoidCallback onResponsibleTap;
  final VoidCallback onCoExecutorTap;
  final VoidCallback onObserverTap;

  const PhaseContractorListItemWidget(
      {Key? key,
      required this.index,
      this.phaseContractor,
      required this.onDeleteTap,
      required this.onContractorTap,
      required this.onResponsibleTap,
      required this.onCoExecutorTap,
      required this.onObserverTap})
      : super(key: key);

  @override
  _PhaseContractorListItemState createState() =>
      _PhaseContractorListItemState();
}

class _PhaseContractorListItemState
    extends State<PhaseContractorListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Container(
            decoration: BoxDecoration(
                color: HexColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 1.0, color: HexColors.grey20)),
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(children: [
                    /// CONTARCTOR NUMBER
                    Expanded(
                        child: Text('${Titles.contractor} ${widget.index}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold))),

                    /// DELETE BUTTON
                    SortObjectButtonWidget(
                        title: Titles.delete,
                        imagePath: '',
                        onTap: () => widget.onDeleteTap()),
                  ]),

                  /// CONTRACTOR SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      isVertical: true,
                      title: Titles.contractor,
                      value: widget.phaseContractor?.contractor?.name ??
                          Titles.notSelected,
                      onTap: () => widget.onContractorTap()),

                  /// RESPONSIBLE SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.responsible,
                      value: widget.phaseContractor?.responsible?.name ??
                          Titles.notAssigned,
                      onTap: () => widget.onResponsibleTap()),

                  /// CO-EXECUTOR SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.coExecutor,
                      value: widget.phaseContractor?.coExecutor?.name ??
                          Titles.notAssigned,
                      onTap: () => widget.onCoExecutorTap()),

                  /// OBSERVER SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.observer,
                      value: widget.phaseContractor?.observer?.name ??
                          Titles.notAssigned,
                      onTap: () => widget.onObserverTap()),
                ])));
  }
}
