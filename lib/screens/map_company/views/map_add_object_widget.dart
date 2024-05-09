import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class MapAddObjectScreenWidget extends StatelessWidget {
  final String title;
  final String address;
  final VoidCallback onTap;

  const MapAddObjectScreenWidget({
    Key? key,
    required this.title,
    required this.address,
    required this.onTap,
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
                  SubtitleWidget(text: address),
                  const SizedBox(height: 16.0),

                  /// BUTTON
                  ButtonWidget(
                    title: title,
                    onTap: () => onTap(),
                  )
                ])));
  }
}
