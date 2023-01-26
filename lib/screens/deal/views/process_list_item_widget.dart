import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/analytics/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/status_widget.dart';

class ProcessListItemWidget extends StatefulWidget {
  final bool isExpanded;
  final bool isReady;
  final VoidCallback onAddProcessTap;
  final VoidCallback onExpandTap;
  final Function(int) onMenuTap;

  const ProcessListItemWidget(
      {Key? key,
      required this.isExpanded,
      required this.isReady,
      required this.onAddProcessTap,
      required this.onExpandTap,
      required this.onMenuTap})
      : super(key: key);

  @override
  _ProcessListItemState createState() => _ProcessListItemState();
}

class _ProcessListItemState extends State<ProcessListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(width: 1.0, color: HexColors.grey20)),
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: [
              /// HEADER
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Row(children: [
                  SvgPicture.asset('assets/ic_done.svg',
                      color: widget.isReady ? null : HexColors.grey20),
                  const SizedBox(width: 12.0),
                  const Expanded(
                      child: Text(Titles.process,
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: 'PT Root UI'))),
                  const SizedBox(width: 12.0),
                  SortObjectButtonWidget(
                      title: '',
                      imagePath: widget.isExpanded
                          ? 'assets/ic_arrow_up.svg'
                          : 'assets/ic_arrow_down.svg',
                      onTap: () => widget.onExpandTap())
                ]),
                onTap: () => widget.onExpandTap(),
              ),
              SizedBox(height: widget.isExpanded ? 16.0 : 0.0),
              widget.isExpanded ? const SeparatorWidget() : Container(),

              /// PROCESS LIST VIEW
              widget.isExpanded
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ListView(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: ListView(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children: [
                                      /// POSITION
                                      Text('Позиция',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: HexColors.black,
                                              fontFamily: 'PT Root UI')),
                                      const SizedBox(height: 6.0),

                                      /// POSITION STATUS
                                      Row(children: const [
                                        StatusWidget(
                                            title: 'Оплачено', status: 0)
                                      ])
                                    ])),
                                const SizedBox(width: 10.0),

                                /// MORE BUTTON
                                SortObjectButtonWidget(
                                    title: '',
                                    imagePath: 'assets/ic_more_vertical.svg',
                                    onTap: () => widget.onMenuTap(index))
                              ]),
                              index == 2
                                  ? Container()
                                  : Column(
                                      children: const [
                                        SizedBox(height: 16.0),
                                        SeparatorWidget()
                                      ],
                                    )
                            ]);
                      })
                  : Container(),

              /// ADD PROCESS BUTTON
              widget.isExpanded
                  ? BorderButtonWidget(
                      title: Titles.addProcess,
                      margin: const EdgeInsets.only(top: 16.0),
                      onTap: () => widget.onAddProcessTap())
                  : Container()
            ]));
  }
}
