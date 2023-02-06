import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/objects_filter_view_model.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';
import 'package:provider/provider.dart';

class ObjectsFilterScreenBodyWidget extends StatefulWidget {
  final VoidCallback onManagerTap;
  final VoidCallback onDeveloperTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ObjectsFilterScreenBodyWidget(
      {Key? key,
      required this.onManagerTap,
      required this.onDeveloperTap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  _ObjectsFilterScreenBodyState createState() =>
      _ObjectsFilterScreenBodyState();
}

class _ObjectsFilterScreenBodyState
    extends State<ObjectsFilterScreenBodyWidget> {
  late ObjectsFilterViewModel _objectsFilterViewModel;

  final options = ['Проектирование', 'Заморожен', 'Строительство', 'Закончен'];
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
    _objectsFilterViewModel =
        Provider.of<ObjectsFilterViewModel>(context, listen: true);

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
                            title: Titles.manager,
                            value: 'Имя Фамилия',
                            onTap: () => widget.onManagerTap()),
                        const SizedBox(height: 10.0),

                        /// DEVELOPER SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.developer,
                            value: 'Название',
                            onTap: () => widget.onDeveloperTap()),

                        const SizedBox(height: 16.0),
                        const TitleWidget(text: Titles.stages, isSmall: true),
                        const SizedBox(height: 10.0),

                        /// STAGES GRID VIEW
                        ChipsChoice<String>.multiple(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            wrapped: true,
                            spacing: 6.0,
                            runSpacing: 6.0,
                            value: options,
                            choiceBuilder: (item, index) => InkWell(
                                  onTap: () => setState(() => {
                                        tags.contains(index)
                                            ? tags.removeWhere(
                                                (element) => element == index)
                                            : tags.add(index)
                                      }),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          color: tags.contains(index)
                                              ? HexColors.additionalViolet
                                              : HexColors.grey10,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(18.0),
                                          )),
                                      child: Text(options[index],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: tags.contains(index)
                                                  ? FontWeight.w500
                                                  : FontWeight.w400,
                                              color: tags.contains(index)
                                                  ? HexColors.white
                                                  : HexColors.black,
                                              fontFamily: 'PT Root UI'))),
                                ),
                            onChanged: (val) => {},
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: options,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            )),

                        const SizedBox(height: 17.0),
                        const TitleWidget(
                            text: Titles.effectiveness, isSmall: true),
                        const SizedBox(height: 10.0),

                        /// EFFECTIVENESS GRID VIEW
                        ChipsChoice<String>.multiple(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            wrapped: true,
                            spacing: 6.0,
                            runSpacing: 6.0,
                            value: options2,
                            choiceBuilder: (item, index) => InkWell(
                                  onTap: () => setState(() => {
                                        tags2.contains(index)
                                            ? tags2.removeWhere(
                                                (element) => element == index)
                                            : tags2.add(index)
                                      }),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                          color: tags2.contains(index)
                                              ? HexColors.additionalViolet
                                              : HexColors.grey10,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(18.0),
                                          )),
                                      child: Text(options2[index],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: tags2.contains(index)
                                                  ? FontWeight.w500
                                                  : FontWeight.w400,
                                              color: tags2.contains(index)
                                                  ? HexColors.white
                                                  : HexColors.black,
                                              fontFamily: 'PT Root UI'))),
                                ),
                            onChanged: (val) => {},
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: options2,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ))
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