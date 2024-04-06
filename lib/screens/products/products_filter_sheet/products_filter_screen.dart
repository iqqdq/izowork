import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:izowork/views/transparent_button_widget_widget.dart';

class ProductsFilterScreenWidget extends StatelessWidget {
  final ProductType? productType;
  final List<String> options;
  final List<int> tags;
  final List<String> options2;
  final List<int> tags2;
  final VoidCallback onTypeTap;
  final Function(int) onTagTap;
  final Function(int) onTag2Tap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ProductsFilterScreenWidget(
      {Key? key,
      this.productType,
      required this.options,
      required this.tags,
      required this.options2,
      required this.tags2,
      required this.onTypeTap,
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
            child: Column(children: [
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
              const SizedBox(height: 17.0),

              /// FILTER CONTENT
              Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      children: [
                    /// TYPE SELECTION INPUT
                    SelectionInputWidget(
                        title: Titles.type,
                        value: productType?.name ?? Titles.notSelected,
                        onTap: () => onTypeTap()),

                    const SizedBox(height: 16.0),
                    const TitleWidget(text: Titles.byAlphabet, isSmall: true),
                    const SizedBox(height: 10.0),

                    /// ALPHABET HORIZONTAL LIST
                    SizedBox(
                        height: 28.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 4.0,
                                    ),
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
                                onTap: () => onTagTap(index),
                              );
                            })),

                    const SizedBox(height: 17.0),
                    const TitleWidget(text: Titles.byPrice, isSmall: true),
                    const SizedBox(height: 10.0),

                    /// PRICE HORIZONTAL LIST
                    SizedBox(
                        height: 28.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: options2.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 4.0,
                                    ),
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
                                onTap: () => onTag2Tap(index),
                              );
                            })),
                    const SizedBox(height: 10.0),
                  ])),

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
              ])
            ])));
  }
}
