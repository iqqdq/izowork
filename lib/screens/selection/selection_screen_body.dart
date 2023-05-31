import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/selection_view_model.dart';
import 'package:izowork/screens/selection/views/selection_list_item_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class SelectionScreenBodyWidget extends StatefulWidget {
  final String title;
  final String value;
  final Function(String) onSelectTap;

  const SelectionScreenBodyWidget(
      {Key? key,
      required this.title,
      required this.value,
      required this.onSelectTap})
      : super(key: key);

  @override
  _SelectionScreenBodyState createState() => _SelectionScreenBodyState();
}

class _SelectionScreenBodyState extends State<SelectionScreenBodyWidget> {
  late SelectionViewModel _selectionViewModel;

  @override
  Widget build(BuildContext context) {
    _selectionViewModel =
        Provider.of<SelectionViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Padding(
            padding: EdgeInsets.only(
                top: 8.0,
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 20.0
                    : MediaQuery.of(context).padding.bottom),
            child: Column(children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),

              /// TITLE
              TitleWidget(text: widget.title),
              const SizedBox(height: 16.0),

              /// SCROLLABLE LIST
              Expanded(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _selectionViewModel.items.length,
                    itemBuilder: (context, index) {
                      return SelectionListItemWidget(
                          isSelected: widget.value.isEmpty
                              ? false
                              : widget.value ==
                                  _selectionViewModel.items[index],
                          name: _selectionViewModel.items[index],
                          onTap: () => _selectionViewModel.select(index));
                    }),
              ),

              const SizedBox(height: 16.0),

              ButtonWidget(
                  title: Titles.apply,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  onTap: () => {
                        widget.onSelectTap(_selectionViewModel
                            .items[_selectionViewModel.index]),
                        Navigator.pop(context)
                      }),
            ])));
  }
}
