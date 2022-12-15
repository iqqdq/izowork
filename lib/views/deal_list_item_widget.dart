import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class DealListItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onTap;

  const DealListItemWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.child,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: Row(children: [
          Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                /// TITLE
                TitleWidget(text: title, isSmall: true),
                const SizedBox(height: 2.0),

                /// SUBTITLE
                SubtitleWidget(text: subtitle)
              ])),
          const SizedBox(width: 10.0),
          child
        ]));
  }
}
