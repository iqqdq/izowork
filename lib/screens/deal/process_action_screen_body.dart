import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/views/title_widget.dart';

class ProcessActionScreenBodyWidget extends StatelessWidget {
  final String title;
  final Function(int) onTap;

  const ProcessActionScreenBodyWidget(
      {Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  TitleWidget(text: title),

                  /// SCROLLABLE LIST
                  ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return BorderButtonWidget(
                            margin: const EdgeInsets.only(top: 16.0),
                            title: index == 0
                                ? Titles.edit
                                : index == 1
                                    ? Titles.stop
                                    : Titles.delete,
                            onTap: () =>
                                {onTap(index), Navigator.pop(context)});
                      })
                ])));
  }
}
