import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/analytics/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';

class PhaseProductListItemWidget extends StatefulWidget {
  final int index;
  final VoidCallback onDeleteTap;
  final VoidCallback onContractorSearchTap;
  final VoidCallback onProductSearchTap;

  const PhaseProductListItemWidget(
      {Key? key,
      required this.index,
      required this.onDeleteTap,
      required this.onContractorSearchTap,
      required this.onProductSearchTap})
      : super(key: key);

  @override
  _PhaseProductListItemState createState() => _PhaseProductListItemState();
}

class _PhaseProductListItemState extends State<PhaseProductListItemWidget> {
  final TextEditingController _timeTextEditingController =
      TextEditingController();
  final FocusNode _timeFocusNode = FocusNode();
  final TextEditingController _countTextEditingController =
      TextEditingController();
  final FocusNode _countFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _timeFocusNode.addListener(() {
      if (_countFocusNode.hasFocus) {
        setState(() => _timeFocusNode.unfocus());
      }
    });

    _countFocusNode.addListener(() {
      if (_timeFocusNode.hasFocus) {
        setState(() => _countFocusNode.unfocus());
      }
    });
  }

  @override
  void dispose() {
    _timeTextEditingController.dispose();
    _timeFocusNode.dispose();
    _countTextEditingController.dispose();
    _countFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                  /// TIME INPUT
                  InputWidget(
                    textEditingController: _timeTextEditingController,
                    focusNode: _timeFocusNode,
                    textInputType: TextInputType.number,
                    margin: const EdgeInsets.only(top: 16.0, bottom: 10.0),
                    height: 56.0,
                    placeholder: Titles.deliveryTimeInMonth,
                    onTap: () => setState,
                    onChange: (text) => {
                      // TODO DESCRTIPTION
                    },
                  ),

                  /// PRODUCT SELECTION INPUT
                  SelectionInputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      isVertical: true,
                      title: Titles.product,
                      value: Titles.notSelected,
                      onTap: () => widget.onProductSearchTap()),

                  /// COUNT INPUT
                  InputWidget(
                      textEditingController: _countTextEditingController,
                      focusNode: _countFocusNode,
                      textInputType: TextInputType.number,
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      placeholder: Titles.count,
                      onTap: () => setState,
                      onChange: (text) => {}),
                ])));
  }
}
