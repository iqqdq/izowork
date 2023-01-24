import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/analytics_actions_view_model.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/date_selection_input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsFilterScreenBodyWidget extends StatefulWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onFilialTap;
  final VoidCallback onFromDateTap;
  final VoidCallback onToDateTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const AnalyticsActionsFilterScreenBodyWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onFilialTap,
      required this.onFromDateTap,
      required this.onToDateTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  _AnalyticsActionsFilterScreenBodyState createState() =>
      _AnalyticsActionsFilterScreenBodyState();
}

class _AnalyticsActionsFilterScreenBodyState
    extends State<AnalyticsActionsFilterScreenBodyWidget> {
  late AnalyticsActionsViewModel _analyticsActionsViewModel;

  final options = [
    'Проектирование',
    'Заморожен',
    'Фундамент',
    'Стены',
    'Внутренние коммуникации'
  ];
  List<int> tags = [];

  final options2 = [
    'Больше 50%',
    'Меньше 50%',
  ];
  List<int> tags2 = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _analyticsActionsViewModel =
        Provider.of<AnalyticsActionsViewModel>(context, listen: true);

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
                        /// MANAGER SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.filial,
                            value: 'Название',
                            onTap: () => widget.onFilialTap()),
                        const SizedBox(height: 10.0),

                        /// DEVELOPER SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.manager,
                            value: 'Название',
                            onTap: () => widget.onManagerTap()),

                        const SizedBox(height: 10.0),
                        DateSelectionInputWidget(
                            title: Titles.fromDate,
                            dateTime: DateTime.now(),
                            onTap: () => widget.onFromDateTap()),
                        const SizedBox(height: 10.0),
                        DateSelectionInputWidget(
                            title: Titles.toDate,
                            dateTime: DateTime.now(),
                            onTap: () => widget.onToDateTap()),
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
                            onTap: () => {
                                  setState(() {
                                    tags.clear();
                                    tags2.clear();
                                  }),
                                  widget.onResetTap()
                                }))
                  ])
                ])));
  }
}
