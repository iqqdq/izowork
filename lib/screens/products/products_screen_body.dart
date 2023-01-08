import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/products_view_model.dart';
import 'package:izowork/screens/products/views/product_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class ProductsScreenBodyWidget extends StatefulWidget {
  const ProductsScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ProductsScreenBodyState createState() => _ProductsScreenBodyState();
}

class _ProductsScreenBodyState extends State<ProductsScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ProductsViewModel _productsViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _productsViewModel = Provider.of<ProductsViewModel>(context, listen: true);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            toolbarHeight: 116.0,
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
                  Text(Titles.products,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  // TODO PRODUCTS CONTACTS
                                },
                            onClearTap: () => {
                                  // TODO CLEAR PRODUCTS SEARCH
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// PRODUCTS LIST VIEW
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 80.0 + MediaQuery.of(context).padding.bottom),
              itemCount: 10,
              itemBuilder: (context, index) {
                return ProductsListItemWidget(
                    tag: index.toString(),
                    onTap: () => _productsViewModel.showProductPageViewScreen(
                        context, index));
              }),
          const SeparatorWidget(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilterButtonWidget(
                    onTap: () =>
                        _productsViewModel.showProdcutFilterSheet(context),
                    // onClearTap: () => {}
                  ))),

          /// INDICATOR
          _productsViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ])));
  }
}
