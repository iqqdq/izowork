import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/api/api.dart';

class ProductsListItemWidget extends StatelessWidget {
  final Product product;
  final String tag;
  final VoidCallback onTap;

  const ProductsListItemWidget(
      {Key? key, required this.product, required this.tag, required this.onTap})
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
                                            BorderRadius.circular(6.0)))),
                            product.image == null
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            productMedialUrl + product.image!,
                                        width: 100.0,
                                        height: 100.0,
                                        memCacheWidth: 100 *
                                            (MediaQuery.of(context)
                                                    .devicePixelRatio)
                                                .round(),
                                        fit: BoxFit.cover))
                          ])),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            /// NAME
                            Expanded(
                                child: Text(product.name,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: HexColors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'PT Root UI',
                                        fontWeight: FontWeight.bold))),

                            /// PRICE
                            Expanded(
                                child: Text(
                                    '${product.price} ${Titles.currency} / ${product.unit}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: HexColors.primaryDark,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold))),
                          ]))
                    ])),
                onTap: () => onTap())));
  }
}
