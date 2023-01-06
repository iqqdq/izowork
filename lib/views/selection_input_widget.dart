import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/title_widget.dart';

class SelectionInputWidget extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const SelectionInputWidget(
      {Key? key, required this.title, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey10,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 11.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: HexColors.grey20),
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            /// TITLE
                            TitleWidget(
                                text: title,
                                isSmall: true,
                                padding: EdgeInsets.zero),

                            /// VALUE
                            Text(value,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w400,
                                    color: HexColors.black))
                          ])),
                      const SizedBox(width: 6.0),
                      Image.asset('assets/ic_arrow_right.png')
                    ])),
                onTap: () => onTap())));
  }
}
