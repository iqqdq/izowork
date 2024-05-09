import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class MoreListItemWidget extends StatelessWidget {
  final bool showSeparator;
  final String title;
  final int? count;
  final VoidCallback onTap;

  const MoreListItemWidget(
      {Key? key,
      required this.showSeparator,
      required this.title,
      this.count,
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
                    child: SeparatorWidget(),
                  )
                : Container(),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: count == null ? 12.0 : 10.0,
                ),
                child: Row(children: [
                  /// TITLE
                  Expanded(
                    child: Text(title,
                        style: TextStyle(
                          color: HexColors.black,
                          fontSize: 16.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.w500,
                        )),
                  ),

                  /// BADGE
                  Badge(
                    largeSize: 24,
                    backgroundColor: HexColors.additionalViolet,
                    label: Text(
                        count.toString().length > 3
                            ? count.toString().substring(0, 2) + '...'
                            : count.toString(),
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: HexColors.white,
                        )),
                    isLabelVisible: count == null ? false : count! > 0,
                  )
                ]))
          ]),
      onTap: () => onTap(),
    );
  }
}
