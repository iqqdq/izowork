import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class MapAddObjectScreenWidget extends StatefulWidget {
  final String address;
  final VoidCallback onTap;
  final VoidCallback onPop;

  const MapAddObjectScreenWidget(
      {Key? key,
      required this.address,
      required this.onTap,
      required this.onPop})
      : super(key: key);

  @override
  _MapAddObjectScreenWidgetState createState() =>
      _MapAddObjectScreenWidgetState();
}

class _MapAddObjectScreenWidgetState extends State<MapAddObjectScreenWidget> {
  @override
  void dispose() {
    widget.onPop();
    super.dispose();
  }

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
                  const TitleWidget(text: Titles.address),
                  const SizedBox(height: 8.0),
                  SubtitleWidget(text: widget.address),
                  const SizedBox(height: 16.0),

                  /// BUTTON
                  ButtonWidget(
                      title: Titles.addObject, onTap: () => widget.onTap())
                ])));
  }
}
