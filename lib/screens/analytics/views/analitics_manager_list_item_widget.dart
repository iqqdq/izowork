import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';

class AnalitycsManagerListItemWidget extends StatelessWidget {
  final double value;
  final VoidCallback onTap;

  const AnalitycsManagerListItemWidget(
      {Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _margin = 16.0;
    final _maxWidth = MediaQuery.of(context).size.width - _margin * 2;

    return Container(
        margin:
            const EdgeInsets.only(bottom: 10.0, left: _margin, right: _margin),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: HexColors.grey20),
            borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    children: [
                      Row(children: [
                        /// AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              width: 24.0, height: 24.0, fit: BoxFit.cover),
                          //   ClipRRect(
                          //   borderRadius: BorderRadius.circular(40.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 80.0, height: 80.0, cacheWidth: 80 * (MediaQuery.of(context).devicePixelRatio).round(), cacheHeight: 80 * (MediaQuery.of(context).devicePixelRatio).round(), fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// USERNAME
                        Expanded(
                            child: Text('Имя Фамилия',
                                style: TextStyle(
                                    color: HexColors.grey90,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(width: 10.0),

                        /// PERCENT
                        Text('${value.toInt()}%',
                            style: TextStyle(
                                color: HexColors.additionalViolet,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold))
                      ]),
                      const SizedBox(height: 10.0),

                      /// INDICATOR
                      Stack(children: [
                        Stack(children: [
                          Container(
                              height: 4.0,
                              decoration: BoxDecoration(
                                  color: HexColors.grey10,
                                  borderRadius: BorderRadius.circular(4.0))),
                          Container(
                              width: _maxWidth / 100 * value,
                              height: 4.0,
                              decoration: BoxDecoration(
                                  color: HexColors.primaryMain,
                                  borderRadius: BorderRadius.circular(4.0)))
                        ])
                      ])
                    ]),
                onTap: () => onTap())));
  }
}
