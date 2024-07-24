import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/views/views.dart';

class ProductScreenWidget extends StatefulWidget {
  final Product product;

  const ProductScreenWidget({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: HexColors.white,
        appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: HexColors.white90,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title: Row(children: [
              const SizedBox(width: 16.0),
              BackButtonWidget(onTap: () => Navigator.pop(context)),
              Expanded(
                child: SelectionArea(
                    child: Text(widget.product.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: HexColors.black,
                            fontSize: 18.0,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 36.0)
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          const SeparatorWidget(),
          ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              children: [
                /// IMAGE
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                            width: 160.0,
                            height: 160.0,
                            decoration: BoxDecoration(
                                color: HexColors.grey20,
                                borderRadius: BorderRadius.circular(6.0)))),
                    widget.product.image == null
                        ? Container()
                        : CachedNetworkImage(
                            imageUrl: productMedialUrl + widget.product.image!,
                            width: 160.0,
                            height: 160.0,
                            memCacheWidth: 160 *
                                (MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            fit: BoxFit.cover),
                  ]),
                ]),
                const SizedBox(height: 16.0),

                /// PRICE
                SelectionArea(
                  child: Text(
                      '${widget.product.price} ${Titles.currency} / ${Titles.kg}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HexColors.primaryDark,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16.0),

                /// COMPANY
                const TitleWidget(
                    text: Titles.company,
                    padding: EdgeInsets.zero,
                    isSmall: true),
                const SizedBox(height: 4.0),
                SelectionArea(
                  child: Text(widget.product.company?.name ?? '-',
                      style: TextStyle(
                          color: HexColors.primaryDark,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline)),
                ),
                const SizedBox(height: 16.0),

                /// PRODUCT TYPE
                const TitleWidget(
                    text: Titles.productType,
                    padding: EdgeInsets.zero,
                    isSmall: true),
                const SizedBox(height: 4.0),
                SelectionArea(
                  child: Text(widget.product.productType?.name ?? '-',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 14.0,
                          fontFamily: 'PT Root UI')),
                ),
                const SizedBox(height: 16.0),

                /// PRODUCT SUBTYPE
                // const TitleWidget(
                //     text: Titles.productSubtype,
                //     padding: EdgeInsets.zero,
                //     isSmall: true),
                // const SizedBox(height: 4.0),
                // SelectionArea(
                //   child: Text('???',
                //       style: TextStyle(
                //           color: HexColors.black,
                //           fontSize: 14.0,
                //           fontFamily: 'PT Root UI')),
                // ),
              ]),
          const SeparatorWidget()
        ])));
  }
}
