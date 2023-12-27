import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/models/product_type_selection_view_model.dart';
import 'package:izowork/screens/selection/views/selection_list_item_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ProductTypeSelectionScreenBodyWidget extends StatefulWidget {
  final bool isRoot;
  final String title;
  final Function(ProductType?) onSelect;

  const ProductTypeSelectionScreenBodyWidget(
      {Key? key,
      required this.title,
      required this.onSelect,
      required this.isRoot})
      : super(key: key);

  @override
  _ProductTypeSelectionScreenBodyState createState() =>
      _ProductTypeSelectionScreenBodyState();
}

class _ProductTypeSelectionScreenBodyState
    extends State<ProductTypeSelectionScreenBodyWidget> {
  late ProductTypeSelectionViewModel _productTypeSelectionViewModel;

  @override
  Widget build(BuildContext context) {
    _productTypeSelectionViewModel = Provider.of<ProductTypeSelectionViewModel>(
      context,
      listen: true,
    );

    return Material(
        type: MaterialType.transparency,
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: widget.isRoot ? 20.0 : 0.0,
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 20.0
                    : MediaQuery.of(context).padding.bottom),
            children: [
              widget.isRoot ? const DismissIndicatorWidget() : Container(),

              /// TITLE
              TitleWidget(text: widget.title),
              const SizedBox(height: 16.0),

              /// SCROLLABLE LIST
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _productTypeSelectionViewModel.productTypes.length,
                  itemBuilder: (context, index) {
                    bool isSelected =
                        _productTypeSelectionViewModel.productType == null
                            ? false
                            : _productTypeSelectionViewModel.productType!.id ==
                                _productTypeSelectionViewModel
                                    .productTypes[index].id;

                    return SelectionListItemWidget(
                        key: ValueKey(_productTypeSelectionViewModel
                            .productTypes[index].id),
                        isSelected: isSelected,
                        name: _productTypeSelectionViewModel
                            .productTypes[index].name,
                        onTap: () =>
                            _productTypeSelectionViewModel.select(index));
                  }),
              const SizedBox(height: 16.0),
              ButtonWidget(
                  title: Titles.apply,
                  isDisabled:
                      _productTypeSelectionViewModel.productType == null,
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 5.0,
                  ),
                  onTap: () => widget
                      .onSelect(_productTypeSelectionViewModel.productType))
            ]));
  }
}
