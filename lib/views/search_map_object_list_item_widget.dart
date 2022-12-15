import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/shadows.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class SearchMapObjectListItemWidget extends StatelessWidget {
  final String address;
  final String name;
  final VoidCallback onTap;

  const SearchMapObjectListItemWidget(
      {Key? key,
      required this.address,
      required this.name,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [Shadows.shadow]),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(text: address, isSmall: true),
                          const SizedBox(height: 2.0),
                          SubtitleWidget(text: name)
                        ])),
                onTap: () => onTap())));
  }
}
