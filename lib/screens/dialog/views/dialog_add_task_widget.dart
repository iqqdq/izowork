import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class DialogAddTaskWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DialogAddTaskWidget({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: HexColors.grey,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 8.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 12.0
                            : MediaQuery.of(context).padding.bottom),
                    shrinkWrap: true,
                    children: [
                      /// DISMISS INDICATOR
                      const DismissIndicatorWidget(),

                      /// ADDRESS
                      const TitleWidget(
                        text: Titles.message,
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SelectionArea(
                            child: Text(text,
                                style: TextStyle(
                                    color: HexColors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI')),
                          )),

                      /// BUTTON
                      ButtonWidget(
                          margin: EdgeInsets.zero,
                          title: Titles.createTask,
                          onTap: () => {Navigator.pop(context), onTap()})
                    ]))));
  }
}
