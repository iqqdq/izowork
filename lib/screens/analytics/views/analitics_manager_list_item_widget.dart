import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class AnalitycsManagerListItemWidget extends StatelessWidget {
  final User? user;
  final double value;
  final VoidCallback onTap;

  const AnalitycsManagerListItemWidget({
    Key? key,
    required this.user,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _margin = 16.0;
    final _maxWidth = MediaQuery.of(context).size.width - _margin * 2;

    return Container(
        margin: const EdgeInsets.only(
          bottom: 10.0,
          left: _margin,
          right: _margin,
        ),
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
                        AvatarWidget(
                          url: avatarUrl,
                          endpoint: user?.avatar,
                          size: 24.0,
                        ),

                        const SizedBox(width: 10.0),

                        /// USERNAME
                        Expanded(
                          child: Text(
                            user?.name ?? '-',
                            style: TextStyle(
                              color: HexColors.grey90,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI',
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
