import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/views.dart';

class ObjectsFilterScreenWidget extends StatelessWidget {
  final User? manager;
  final Company? designer;
  final Company? contractor;
  final Company? customer;
  final List<String> options;
  final List<int> tags;
  final List<String> options2;
  final List<int> tags2;
  final VoidCallback onManagerTap;
  final VoidCallback onDesignerTap;
  final VoidCallback onContractorTap;
  final VoidCallback onCustomerTap;
  final Function(int) onTagTap;
  final Function(int) onTag2Tap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ObjectsFilterScreenWidget(
      {Key? key,
      this.manager,
      this.designer,
      this.contractor,
      this.customer,
      required this.options,
      required this.tags,
      required this.options2,
      required this.tags2,
      required this.onManagerTap,
      required this.onDesignerTap,
      required this.onContractorTap,
      required this.onCustomerTap,
      required this.onTagTap,
      required this.onTag2Tap,
      required this.onApplyTap,
      required this.onResetTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom == 0.0
                  ? 12.0
                  : MediaQuery.of(context).padding.bottom),
          color: HexColors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// TITLE
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleWidget(text: Titles.filter),
                      BackButtonWidget(
                        asset: 'assets/ic_close.svg',
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),

                /// FILTER CONTENT
                Expanded(
                  child: ListView(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 8.0),
                      children: [
                        const SizedBox(height: 17.0),

                        /// CONTENT LIST
                        ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              /// MANAGER SELECTION INPUT
                              SelectionInputWidget(
                                  title: Titles.manager,
                                  value: manager?.name ?? Titles.notSelected,
                                  onTap: () => onManagerTap()),
                              const SizedBox(height: 10.0),

                              /// CONTRACTOR SELECTION INPUT
                              SelectionInputWidget(
                                  title: Titles.contractor,
                                  value: contractor?.name ?? Titles.notSelected,
                                  onTap: () => onContractorTap()),
                              const SizedBox(height: 10.0),

                              /// CUSTOMER SELECTION INPUT
                              SelectionInputWidget(
                                  title: Titles.customer,
                                  value: customer?.name ?? Titles.notSelected,
                                  onTap: () => onCustomerTap()),
                              const SizedBox(height: 10.0),

                              /// DESGINER SELECTION INPUT
                              SelectionInputWidget(
                                  title: Titles.designer,
                                  value: designer?.name ?? Titles.notSelected,
                                  onTap: () => onDesignerTap()),

                              const SizedBox(height: 16.0),
                              const TitleWidget(
                                  text: Titles.stages, isSmall: true),
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
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 4.0,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: tags.contains(index)
                                                      ? HexColors
                                                          .additionalViolet
                                                      : HexColors.grey10,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(18.0),
                                                  )),
                                              child: Text(options[index],
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          tags.contains(index)
                                                              ? FontWeight.w500
                                                              : FontWeight.w400,
                                                      color:
                                                          tags.contains(index)
                                                              ? HexColors.white
                                                              : HexColors.black,
                                                      fontFamily:
                                                          'PT Root UI'))),
                                          onTap: () => onTagTap(index),
                                        );
                                      })),

                              const SizedBox(height: 17.0),
                              const TitleWidget(
                                  text: Titles.effectiveness, isSmall: true),
                              const SizedBox(height: 10.0),

                              /// EFFECTIVENES HORIZONTAL LIST
                              SizedBox(
                                  height: 28.0,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 0.0,
                                      ),
                                      itemCount: options2.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                  color: tags2.contains(index)
                                                      ? HexColors
                                                          .additionalViolet
                                                      : HexColors.grey10,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(18.0),
                                                  )),
                                              child: Text(options2[index],
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          tags2.contains(index)
                                                              ? FontWeight.w500
                                                              : FontWeight.w400,
                                                      color:
                                                          tags2.contains(index)
                                                              ? HexColors.white
                                                              : HexColors.black,
                                                      fontFamily:
                                                          'PT Root UI'))),
                                          onTap: () => onTag2Tap(index),
                                        );
                                      }))
                            ]),
                        const SizedBox(height: 10.0),
                      ]),
                ),

                /// BUTTON's
                Row(children: [
                  /// APPLY
                  Expanded(
                      child: ButtonWidget(
                          title: Titles.apply,
                          margin: const EdgeInsets.only(left: 16.0, right: 5.0),
                          onTap: () => onApplyTap())),

                  /// RESET
                  Expanded(
                      child: TransparentButtonWidget(
                          title: Titles.reset,
                          margin: const EdgeInsets.only(left: 5.0, right: 16.0),
                          onTap: () => onResetTap()))
                ]),
              ]),
        ));
  }
}
