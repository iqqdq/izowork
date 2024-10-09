import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/selection/view_model/selection_view_model.dart';

import 'package:izowork/features/selection/view/views/selection_list_item_widget.dart';
import 'package:izowork/views/views.dart';
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
  final ScrollController _scrollController = ScrollController();
  late SelectionViewModel _selectionViewModel;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectionViewModel = Provider.of<SelectionViewModel>(
      context,
      listen: true,
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: HexColors.white,
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (_scrollController.position.pixels == 0.0 &&
                MediaQuery.of(context).viewInsets.bottom == 0.0) {
              Navigator.pop(context);
            }

            // Return true to cancel the notification bubbling. Return false (or null) to
            // allow the notification to continue to be dispatched to further ancestors.
            return true;
          },
          child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: (MediaQuery.of(context).padding.bottom == 0.0
                          ? 20.0
                          : MediaQuery.of(context).padding.bottom) +
                      MediaQuery.of(context).viewInsets.bottom),
              children: [
                /// DISMISS INDICATOR
                const SizedBox(height: 6.0),
                const DismissIndicatorWidget(),

                /// TITLE
                TitleWidget(padding: EdgeInsets.zero, text: widget.title),
                const SizedBox(height: 16.0),

                /// SCROLLABLE LIST
                SizedBox(
                  height: 64.0 * _selectionViewModel.items.length,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _selectionViewModel.items.length,
                      itemBuilder: (context, index) {
                        final item = _selectionViewModel.items[index];

                        return SelectionListItemWidget(
                            isSelected: widget.value == item &&
                                    _selectionViewModel.index == -1
                                ? true
                                : _selectionViewModel.index == index,
                            name: item,
                            onTap: () => _selectionViewModel.select(index));
                      }),
                ),

                const SizedBox(height: 16.0),

                ButtonWidget(
                    title: Titles.apply,
                    margin: EdgeInsets.zero,
                    onTap: () => {
                          _selectionViewModel.index == -1
                              ? widget.onSelectTap(widget.value)
                              : widget.onSelectTap(_selectionViewModel
                                  .items[_selectionViewModel.index]),
                          Navigator.pop(context)
                        }),
              ]),
        ),
      ),
    );
  }
}
