import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class MapAddObjectWidget extends StatelessWidget {
  final String address;
  final VoidCallback onTap;

  const MapAddObjectWidget(
      {Key? key, required this.address, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const DismissIndicatorWidget(),

                  /// ADDRESS
                  const TitleWidget(text: Titles.placeAddress),
                  const SizedBox(height: 4.0),
                  SubtitleWidget(text: address),
                  const SizedBox(height: 16.0),

                  /// BUTTON
                  ButtonWidget(title: Titles.addObject, onTap: () => onTap())
                ])));
  }
}
