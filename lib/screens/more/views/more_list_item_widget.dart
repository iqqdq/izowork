import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/separator_widget.dart';

class MoreListItemWidget extends StatelessWidget {
  final bool showSeparator;
  final String title;
  final VoidCallback onTap;

  const MoreListItemWidget(
      {Key? key,
      required this.showSeparator,
      required this.title,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: HexColors.grey20,
        splashColor: Colors.transparent,
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              showSeparator
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SeparatorWidget())
                  : Container(),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child:

                          /// TITLE
                          Text(title,
                              style: TextStyle(
                                  color: HexColors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'PT Root UI',
                                  fontWeight: FontWeight.w500))))
            ]),
        onTap: () => onTap());
  }
}
