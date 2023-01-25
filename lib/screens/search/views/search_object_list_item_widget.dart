import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/subtitle_widget.dart';
import 'package:izowork/views/title_widget.dart';

class SearchObjectListItemWidget extends StatelessWidget {
  final String address;
  final String name;
  final VoidCallback onTap;

  const SearchObjectListItemWidget(
      {Key? key,
      required this.address,
      required this.name,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: HexColors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border:
                            Border.all(width: 0.5, color: HexColors.grey20)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleWidget(text: address, isSmall: true),
                              const SizedBox(height: 2.0),
                              SubtitleWidget(text: name)
                            ]))),
                onTap: () => onTap())));
  }
}
