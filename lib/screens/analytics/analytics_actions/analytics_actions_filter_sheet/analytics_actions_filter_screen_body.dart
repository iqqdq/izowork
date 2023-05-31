import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/date_selection_input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';

class AnalyticsActionsFilterScreenBodyWidget extends StatefulWidget {
  final Office? office;
  final User? manager;
  final DateTime? fromDateTime;
  final DateTime? toDateTime;
  final VoidCallback onOfficeTap;
  final VoidCallback onManagerTap;
  final VoidCallback onFromDateTimeTap;
  final VoidCallback onToDateTimeTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const AnalyticsActionsFilterScreenBodyWidget({
    Key? key,
    this.office,
    this.manager,
    this.fromDateTime,
    this.toDateTime,
    required this.onOfficeTap,
    required this.onManagerTap,
    required this.onFromDateTimeTap,
    required this.onToDateTimeTap,
    required this.onApplyTap,
    required this.onResetTap,
  }) : super(key: key);

  @override
  _AnalyticsActionsFilterScreenBodyState createState() =>
      _AnalyticsActionsFilterScreenBodyState();
}

class _AnalyticsActionsFilterScreenBodyState
    extends State<AnalyticsActionsFilterScreenBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 8.0),
                children: [
                  /// TITLE
                  const TitleWidget(text: Titles.filter),
                  const SizedBox(height: 17.0),

                  /// SCROLLABLE LIST
                  ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      children: [
                        /// OFFICE SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.filial,
                            value: widget.office?.name ?? Titles.notSelected,
                            onTap: () => widget.onOfficeTap()),
                        const SizedBox(height: 10.0),

                        /// MANAGER SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.manager,
                            value: widget.manager?.name ?? Titles.notSelected,
                            onTap: () => widget.onManagerTap()),

                        const SizedBox(height: 10.0),
                        DateSelectionInputWidget(
                            title: Titles.fromDate,
                            dateTime: widget.fromDateTime,
                            onTap: () => widget.onFromDateTimeTap()),
                        const SizedBox(height: 10.0),
                        DateSelectionInputWidget(
                            title: Titles.toDate,
                            dateTime: widget.toDateTime,
                            onTap: () => widget.onToDateTimeTap()),
                      ]),

                  /// BUTTON's
                  Row(children: [
                    /// APPLY
                    Expanded(
                        child: ButtonWidget(
                            title: Titles.apply,
                            margin:
                                const EdgeInsets.only(left: 16.0, right: 5.0),
                            onTap: () => widget.onApplyTap())),

                    /// RESET
                    Expanded(
                        child: TransparentButtonWidget(
                            title: Titles.reset,
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 16.0),
                            onTap: () => widget.onResetTap()))
                  ])
                ])));
  }
}
