import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/entities/response/trace.dart';

class AnalitycsActionListItemWidget extends StatelessWidget {
  final Trace trace;
  final VoidCallback onTap;

  const AnalitycsActionListItemWidget(
      {Key? key, required this.trace, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _day = trace.createdAt.day.toString().length == 1
        ? '0${trace.createdAt.day}'
        : '${trace.createdAt.day}';
    final _month = trace.createdAt.month.toString().length == 1
        ? '0${trace.createdAt.month}'
        : '${trace.createdAt.month}';
    final _year = '${trace.createdAt.year}';

    return Material(
        color: Colors.transparent,
        child: InkWell(
            highlightColor: HexColors.grey20,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
                margin: const EdgeInsets.only(
                    bottom: 10.0, left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: HexColors.grey20),
                    borderRadius: BorderRadius.circular(16.0)),
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      /// TITLE
                      Text(trace.description ?? '-',
                          style: TextStyle(
                              color: HexColors.grey90,
                              fontSize: 18.0,
                              fontFamily: 'PT Root UI',
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// DATE
                            Row(children: [
                              Text('$_day.$_month.$_year',
                                  style: TextStyle(
                                      color: HexColors.grey30,
                                      fontSize: 14.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(width: 10.0)
                            ]),

                            /// LOCATION
                            Row(children: [
                              SvgPicture.asset('assets/ic_pin.svg'),
                              const SizedBox(width: 2.0),
                              Text(trace.office?.name ?? '-',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: HexColors.additionalViolet,
                                      fontSize: 14.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'PT Root UI',
                                      fontWeight: FontWeight.bold))
                            ])
                          ])
                    ])),
            onTap: () => onTap()));
  }
}
