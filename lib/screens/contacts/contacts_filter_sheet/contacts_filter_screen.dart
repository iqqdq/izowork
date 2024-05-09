import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class ContactsFilterScreenWidget extends StatelessWidget {
  final List<String> options;
  final List<int> tags;
  final List<String> options2;
  final List<int> tags2;
  final Function(int) onTagTap;
  final Function(int) onTag2Tap;
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ContactsFilterScreenWidget(
      {Key? key,
      required this.options,
      required this.tags,
      required this.options2,
      required this.tags2,
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

              /// SCROLLABLE LIST
              Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
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
                                key: ValueKey(options.length),
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
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
                                onTap: () => onTagTap(index),
                              );
                            })),

                    const SizedBox(height: 17.0),
                    const TitleWidget(text: Titles.type, isSmall: true),
                    const SizedBox(height: 10.0),

                    /// TYPE HORIZONTAL LIST
                    SizedBox(
                        height: 28.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: options2.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                key: ValueKey(options2[index]),
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
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
                                onTap: () => onTag2Tap(index),
                              );
                            })),
                  ])),
              const SizedBox(height: 17.0),

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
