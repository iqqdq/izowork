import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/object.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';

class DealsFilterScreenWidget extends StatelessWidget {
  final User? responsible;
  final Object? object;
  final Company? company;
  final List<String> options;
  final List<int> tags;
  final VoidCallback onResponsibleTap;
  final VoidCallback onObjectTap;
  final VoidCallback onCompanyTap;
  final Function(int) onTagTap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const DealsFilterScreenWidget({
    Key? key,
    this.responsible,
    this.object,
    this.company,
    required this.options,
    required this.tags,
    required this.onResponsibleTap,
    required this.onObjectTap,
    required this.onCompanyTap,
    required this.onTagTap,
    required this.onApplyTap,
    required this.onResetTap,
  }) : super(key: key);

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

                  /// CONTENT LIST
                  ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      children: [
                        /// RESPONSIBLE SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.responsible,
                            value: responsible?.name ?? Titles.notSelected,
                            onTap: () => onResponsibleTap()),
                        const SizedBox(height: 10.0),

                        /// OBJECT SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.object,
                            value: object?.name ?? Titles.notSelected,
                            onTap: () => onObjectTap()),
                        const SizedBox(height: 10.0),

                        /// COMPANY SELECTION INPUT
                        SelectionInputWidget(
                            title: Titles.company,
                            value: company?.name ?? Titles.notSelected,
                            onTap: () => onCompanyTap()),

                        const SizedBox(height: 16.0),
                        const TitleWidget(text: Titles.stages, isSmall: true),
                        const SizedBox(height: 10.0),

                        /// STAGE HORIZONTAL LIST
                        SizedBox(
                            height: 28.0,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                            color: tags.contains(index)
                                                ? HexColors.additionalViolet
                                                : HexColors.grey10,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                    onTap: () => onTagTap(index),
                                  );
                                })),
                        const SizedBox(height: 20.0),

                        /// BUTTON's
                        Row(children: [
                          /// APPLY
                          Expanded(
                              child: ButtonWidget(
                                  title: Titles.apply,
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 5.0),
                                  onTap: () => onApplyTap())),

                          /// RESET
                          Expanded(
                              child: TransparentButtonWidget(
                                  title: Titles.reset,
                                  margin: const EdgeInsets.only(
                                      left: 5.0, right: 16.0),
                                  onTap: () => onResetTap()))
                        ])
                      ])
                ])));
  }
}
