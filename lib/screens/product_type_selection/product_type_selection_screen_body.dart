import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/product_type.dart';
import 'package:izowork/models/product_type_selection_view_model.dart';
import 'package:izowork/screens/selection/views/selection_list_item_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ProductTypeSelectionScreenBodyWidget extends StatefulWidget {
  final Function(ProductType?) onSelect;

  const ProductTypeSelectionScreenBodyWidget({Key? key, required this.onSelect})
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
    _productTypeSelectionViewModel =
        Provider.of<ProductTypeSelectionViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: SizedBox.expand(
                child: Stack(children: [
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 20.0
                          : MediaQuery.of(context).padding.bottom),
                  child: Column(children: [
                    /// TITLE
                    const TitleWidget(text: Titles.objectType),
                    const SizedBox(height: 16.0),

                    /// SCROLLABLE LIST
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            itemCount: _productTypeSelectionViewModel
                                .productTypes.length,
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  _productTypeSelectionViewModel.productType ==
                                          null
                                      ? false
                                      : _productTypeSelectionViewModel
                                              .productType!.id ==
                                          _productTypeSelectionViewModel
                                              .productTypes[index].id;

                              return SelectionListItemWidget(
                                  isSelected: isSelected,
                                  name: _productTypeSelectionViewModel
                                      .productTypes[index].name,
                                  onTap: () => _productTypeSelectionViewModel
                                      .select(index));
                            })),
                    ButtonWidget(
                        title: Titles.apply,
                        margin: const EdgeInsets.only(left: 16.0, right: 5.0),
                        onTap: () => widget.onSelect(
                            _productTypeSelectionViewModel.productType))
                  ])),

              /// INDICATOR
              _productTypeSelectionViewModel.loadingStatus ==
                      LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ]))));
  }
}
