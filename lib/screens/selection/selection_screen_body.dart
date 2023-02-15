import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/selection_view_model.dart';
import 'package:izowork/screens/selection/views/selection_list_item_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class SelectionScreenBodyWidget extends StatefulWidget {
  final String title;
  final Function(String) onSelectTap;

  const SelectionScreenBodyWidget(
      {Key? key, required this.title, required this.onSelectTap})
      : super(key: key);

  @override
  _SelectionScreenBodyState createState() => _SelectionScreenBodyState();
}

class _SelectionScreenBodyState extends State<SelectionScreenBodyWidget> {
  late SelectionViewModel _selectionViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectionViewModel =
        Provider.of<SelectionViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.white,
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 20.0
                        : MediaQuery.of(context).padding.bottom),
                children: [
                  /// DISMISS INDICATOR
                  const SizedBox(height: 6.0),
                  const DismissIndicatorWidget(),

                  /// TITLE
                  TitleWidget(text: widget.title),
                  const SizedBox(height: 17.0),

                  /// SCROLLABLE LIST
                  ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _selectionViewModel.items.length,
                      itemBuilder: (context, index) {
                        return SelectionListItemWidget(
                            isSelected: _selectionViewModel.index == index,
                            name: _selectionViewModel.items[index],
                            onTap: () => _selectionViewModel.select(index));
                      }),

                  ButtonWidget(
                      title: Titles.apply,
                      margin: const EdgeInsets.only(left: 16.0, right: 5.0),
                      onTap: () => {
                            widget.onSelectTap(_selectionViewModel
                                .items[_selectionViewModel.index]),
                            Navigator.pop(context)
                          }),
                ])));
  }
}
