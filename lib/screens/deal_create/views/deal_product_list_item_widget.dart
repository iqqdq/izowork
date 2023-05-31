import 'package:flutter/material.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal.dart';
import 'package:izowork/screens/analytics/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';

class DealProductListItemWidget extends StatefulWidget {
  final int index;
  final DealProduct dealProduct;
  final VoidCallback onProductSearchTap;
  final Function(String) onWeightChange;
  final VoidCallback onDeleteTap;

  const DealProductListItemWidget(
      {Key? key,
      required this.index,
      required this.dealProduct,
      required this.onProductSearchTap,
      required this.onDeleteTap,
      required this.onWeightChange})
      : super(key: key);

  @override
  _DealProductListItemState createState() => _DealProductListItemState();
}

class _DealProductListItemState extends State<DealProductListItemWidget> {
  final TextEditingController _weightTextEditingController =
      TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _weightFocusNode.addListener(() {
      if (_priceFocusNode.hasFocus) {
        setState(() => _weightFocusNode.unfocus());
      }
    });

    _priceFocusNode.addListener(() {
      if (_weightFocusNode.hasFocus) {
        setState(() => _priceFocusNode.unfocus());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _weightTextEditingController.text = widget.dealProduct.count == 0
          ? ''
          : widget.dealProduct.count.toString();
    });
  }

  @override
  void dispose() {
    _weightTextEditingController.dispose();
    _weightFocusNode.dispose();
    _priceTextEditingController.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _price = widget.dealProduct.product?.price == null
        ? 0
        : widget.dealProduct.product!.price!.toDouble() *
            (_weightTextEditingController.text.isEmpty
                ? 1.0
                : (double.tryParse(_weightTextEditingController.text) ?? 0));

    _priceTextEditingController.text =
        widget.dealProduct.product?.price?.toString() ?? '';

    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Container(
            decoration: BoxDecoration(
                color: HexColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 1.0, color: HexColors.grey20)),
            child: ListView(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(children: [
                    /// PRODUCT NUMBER
                    Expanded(
                        child: Text('${Titles.product} ${widget.index}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold))),

                    /// DELETE BUTTON
                    SortObjectButtonWidget(
                        title: Titles.delete,
                        imagePath: '',
                        onTap: () => widget.onDeleteTap()),
                  ]),

                  /// PRODUCT SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      isVertical: true,
                      title: Titles.product,
                      value: widget.dealProduct.product?.name ??
                          Titles.notSelected,
                      onTap: () => widget.onProductSearchTap()),

                  /// WEIGHT INPUT
                  Opacity(
                      opacity: widget.dealProduct.product == null ? 0.5 : 1.0,
                      child: IgnorePointer(
                          ignoring: widget.dealProduct.product == null,
                          child: InputWidget(
                            textEditingController: _weightTextEditingController,
                            focusNode: _weightFocusNode,
                            textInputType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            margin: const EdgeInsets.only(bottom: 10.0),
                            height: 56.0,
                            placeholder: '${Titles.weight}, ${Titles.kg}',
                            onTap: () => setState,
                            onChange: (text) => setState(() => _debouncer
                                .run(() => widget.onWeightChange(text))),
                          ))),

                  /// PRICE INPUT
                  Opacity(
                      opacity: widget.dealProduct.product == null ? 0.5 : 1.0,
                      child: IgnorePointer(
                          ignoring: true,
                          child: InputWidget(
                              textEditingController:
                                  _priceTextEditingController,
                              focusNode: _priceFocusNode,
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              margin: const EdgeInsets.only(bottom: 10.0),
                              height: 56.0,
                              placeholder:
                                  '${Titles.priceFor} 1 ${Titles.kg}, ${Titles.currency}',
                              onTap: () => setState,
                              onChange: (text) => null))),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('${Titles.totalPrice}, ${Titles.currency}',
                          style: TextStyle(
                              color: HexColors.grey50, fontSize: 12.0))),
                  const SizedBox(height: 4.0),

                  /// TOTAL PRICE
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          widget.dealProduct.count == 0
                              ? '0'
                              : _price % 1 == 0
                                  ? _price.toInt().toString()
                                  : _price.toString(),
                          style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI')))
                ])));
  }
}
