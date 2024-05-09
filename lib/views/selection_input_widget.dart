import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class SelectionInputWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool? isVertical;
  final bool? isDate;
  final EdgeInsets? margin;
  final VoidCallback onTap;

  const SelectionInputWidget(
      {Key? key,
      required this.title,
      required this.value,
      this.isVertical,
      this.isDate,
      this.margin,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isDate = isDate == null
        ? false
        : isDate == false
            ? false
            : true;

    final _isVertical = isVertical == null
        ? false
        : isVertical == false
            ? false
            : true;

    return Padding(
        padding: margin ?? const EdgeInsets.symmetric(horizontal: 16.0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey10,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: title.isEmpty ? 16.0 : 11.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: HexColors.grey20),
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            /// TITLE
                            title.isEmpty
                                ? Container()
                                : TitleWidget(
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
                      SvgPicture.asset(_isDate
                          ? 'assets/ic_calendar.svg'
                          : _isVertical
                              ? 'assets/ic_arrow_down.svg'
                              : 'assets/ic_arrow_right.svg')
                    ])),
                onTap: () => onTap())));
  }
}
