import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';

class ProductsListItemWidget extends StatelessWidget {
  final String tag;
  final VoidCallback onTap;

  const ProductsListItemWidget(
      {Key? key, required this.tag, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 132.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 0.5, color: HexColors.grey30)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: HexColors.grey20,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      /// IMAGE
                      Hero(
                          tag: tag,
                          child: Stack(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                        color: HexColors.grey20,
                                        borderRadius:
                                            BorderRadius.circular(6.0))))

                            // CachedNetworkImage(imageUrl: '', width: 100.0, height: 100.0,  cacheWidth: 100 *
                            //     (MediaQuery.of(context).devicePixelRatio)
                            //         .round(),
                            // cacheHeight: 100 *
                            //     (MediaQuery.of(context).devicePixelRatio)
                            //         .round(), fit: BoxFit.cover),
                          ])),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            /// NAME
                            Expanded(
                                child: Text(
                                    'Грунтовка глубокого прониковения “Интерьер”',
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: HexColors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold))),

                            /// PRICE
                            Expanded(
                                child: Text('17 548 ₸ / кг',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: HexColors.primaryDark,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold))),
                          ]))
                    ])),
                onTap: () => onTap())));
  }
}
