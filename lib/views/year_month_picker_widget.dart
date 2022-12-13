import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/helpers/string_casing_extension.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class YearMonthPickerWidget extends StatelessWidget {
  final VoidCallback onTap;

  const YearMonthPickerWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 8.0),
            children: [
              Center(
                  child: Container(
                      width: 40.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                          color: HexColors.gray30,
                          borderRadius: BorderRadius.circular(4.0)))),
              Container(
                  margin: const EdgeInsets.only(top: 32.0),
                  height: 191.0,
                  child: Stack(children: [
                    Center(
                        child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      width: double.infinity,
                      height: 32.0,
                      color: HexColors.white,
                    )),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 134.0,
                              height: 191.0,
                              child: WheelChooser(
                                  isInfinite: true,
                                  perspective: 0.005,
                                  itemSize: 36.0,
                                  startPosition: DateTime.now().month,
                                  selectTextStyle: TextStyle(
                                      fontSize: 14.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w500,
                                      color: HexColors.black),
                                  unSelectTextStyle: TextStyle(
                                      fontSize: 12.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w400,
                                      color: HexColors.gray70),
                                  onValueChanged: (value) =>
                                      {debugPrint(value)},
                                  datas: [
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 1))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 2))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 3))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 4))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 5))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 6))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 7))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 8))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 9))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 10))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 11))
                                        .toCapitalized(),
                                    DateFormat.MMMM('ru')
                                        .format(
                                            DateTime(DateTime.now().year, 12))
                                        .toCapitalized(),
                                  ])),
                          SizedBox(
                              width: 134.0,
                              height: 191.0,
                              child: WheelChooser(
                                  isInfinite: true,
                                  perspective: 0.005,
                                  itemSize: 36.0,
                                  startPosition: 3,
                                  selectTextStyle: TextStyle(
                                      fontSize: 14.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w500,
                                      color: HexColors.black),
                                  unSelectTextStyle: TextStyle(
                                      fontSize: 12.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w400,
                                      color: HexColors.gray70),
                                  onValueChanged: (value) =>
                                      {debugPrint(value)},
                                  datas: [
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year - 3)),
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year - 2)),
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year - 1)),
                                    DateFormat.y()
                                        .format(DateTime(DateTime.now().year)),
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year + 1)),
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year + 2)),
                                    DateFormat.y().format(
                                        DateTime(DateTime.now().year + 3)),
                                  ]))
                        ])
                  ])),
              const SizedBox(height: 32.0),
              ButtonWidget(
                  title: Titles.apply,
                  onTap: () => {onTap(), Navigator.pop(context)}),
              SizedBox(
                  height: MediaQuery.of(context).padding.bottom == 0.0
                      ? 12.0
                      : MediaQuery.of(context).padding.bottom)
            ]));
  }
}
