import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';

class ObjectCommentListItemWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ObjectCommentListItemWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: HexColors.grey, borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      /// AUTHOR
                      Row(children: [
                        /// AUTHOR AVATAR
                        Stack(children: [
                          SvgPicture.asset('assets/ic_avatar.svg',
                              color: HexColors.grey40,
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(12.0),
                          //   child:
                          // CachedNetworkImage(imageUrl: '', width: 24.0, height: 24.0, fit: BoxFit.cover)),
                        ]),
                        const SizedBox(width: 10.0),

                        /// AUTHOR NAME
                        Expanded(
                            child: Text('Имя Фамилия',
                                style: TextStyle(
                                    color: HexColors.grey50,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w700)))
                      ]),
                      const SizedBox(height: 10.0),

                      /// COMMENT
                      Text(
                          'Семантический разбор внешних противодействий играет определяющее...',
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI')),
                    ]),
                onTap: () => onTap())));
  }
}
