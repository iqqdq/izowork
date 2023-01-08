import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ProductPageScreenWidget extends StatefulWidget {
  final String tag;

  const ProductPageScreenWidget({Key? key, required this.tag})
      : super(key: key);

  @override
  _ProductPageScreenState createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: HexColors.white,
        appBar: AppBar(
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: HexColors.white90,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Название товара',
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
            ])),
        body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            shrinkWrap: true,
            children: [
              /// IMAGE
              Center(
                  child: Hero(
                      tag: widget.tag,
                      child: Stack(children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                                width: 160.0,
                                height: 160.0,
                                decoration: BoxDecoration(
                                    color: HexColors.grey20,
                                    borderRadius: BorderRadius.circular(6.0))))

                        // CachedNetworkImage(imageUrl: '', width: 160.0, height: 160.0,  cacheWidth: 100160 *
                        //     (MediaQuery.of(context).devicePixelRatio)
                        //         .round(),
                        // cacheHeight: 160 *
                        //     (MediaQuery.of(context).devicePixelRatio)
                        //         .round(), fit: BoxFit.cover),
                      ]))),
              const SizedBox(height: 16.0),

              /// PRICE
              Text('17 548 ₸ / кг',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColors.primaryDark,
                      fontSize: 20.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),

              /// COMPANY
              const TitleWidget(
                  text: Titles.company,
                  padding: EdgeInsets.zero,
                  isSmall: true),
              const SizedBox(height: 4.0),
              Text('Уралкалий',
                  style: TextStyle(
                      color: HexColors.primaryDark,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline)),
              const SizedBox(height: 16.0),

              /// PRODUCT TYPE
              const TitleWidget(
                  text: Titles.productType,
                  padding: EdgeInsets.zero,
                  isSmall: true),
              const SizedBox(height: 4.0),
              Text('Смеси',
                  style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI')),
              const SizedBox(height: 16.0),

              /// PRODUCT SUBTYPE
              const TitleWidget(
                  text: Titles.productSubtype,
                  padding: EdgeInsets.zero,
                  isSmall: true),
              const SizedBox(height: 4.0),
              Text('Смеси',
                  style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI'))
            ]));
  }
}
