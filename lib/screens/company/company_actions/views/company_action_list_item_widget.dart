import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';

class CompanyActionListItemWidget extends StatelessWidget {
  final CompanyAction companyAction;

  const CompanyActionListItemWidget({
    Key? key,
    required this.companyAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: HexColors.grey20,
          ),
          borderRadius: BorderRadius.circular(16.0)),
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            /// TEXT
            Text(
              companyAction.description ?? '-',
              style: TextStyle(
                color: HexColors.grey90,
                fontSize: 16.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              /// DATE
              Row(children: [
                Text(
                    companyAction.createdAt == null
                        ? ''
                        : DateTimeFormatter().formatDateTimeToString(
                            dateTime: companyAction.createdAt!,
                            showTime: true,
                            showMonthName: true,
                          ),
                    style: TextStyle(
                      color: HexColors.grey30,
                      fontSize: 14.0,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(width: 10.0)
              ]),

              /// LOCATION
              // Row(children: [
              //   SvgPicture.asset('assets/ic_pin.svg'),
              //   const SizedBox(width: 2.0),
              //   Text(trace.office?.name ?? '-',
              //       textAlign: TextAlign.end,
              //       style: TextStyle(
              //         color: HexColors.additionalViolet,
              //         fontSize: 14.0,
              //         overflow: TextOverflow.ellipsis,
              //         fontFamily: 'PT Root UI',
              //         fontWeight: FontWeight.bold,
              //       ))
              // ]),
            ]),
          ]),
    );
  }
}
