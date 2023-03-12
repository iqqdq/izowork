import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/deal_process.dart';
import 'package:izowork/entities/response/deal_stage.dart';
import 'package:izowork/screens/analytics/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/status_widget.dart';

class ProcessListItemWidget extends StatefulWidget {
  final DealStage dealStage;
  final List<DealProcess> dealProcesses;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(DealProcess) onProcessTap;
  final Function(DealProcess) onMenuTap;
  final VoidCallback? onAddProcessTap;

  const ProcessListItemWidget(
      {Key? key,
      required this.dealStage,
      required this.dealProcesses,
      required this.isExpanded,
      required this.onProcessTap,
      this.onAddProcessTap,
      required this.onTap,
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
                  borderRadius: BorderRadius.circular(16.0),
                  child: Row(children: [
                    SvgPicture.asset('assets/ic_done.svg',
                        color:
                            widget.dealStage.locked ? HexColors.grey20 : null),
                    const SizedBox(width: 12.0),
                    Expanded(
                        child: Text(widget.dealStage.name,
                            style: const TextStyle(
                                fontSize: 16.0, fontFamily: 'PT Root UI'))),
                    const SizedBox(width: 12.0),
                    SortObjectButtonWidget(
                        title: '',
                        imagePath: widget.isExpanded
                            ? 'assets/ic_arrow_up.svg'
                            : 'assets/ic_arrow_down.svg',
                        onTap: () => widget.onTap())
                  ]),
                  onTap: () => widget.onTap()),

              /// PROCESS LIST VIEW
              widget.isExpanded
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.dealProcesses.length,
                      itemBuilder: (context, index) {
                        return widget.dealProcesses[index].hidden
                            ? Container()
                            : InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0),
                                child: ListView(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      widget.dealProcesses[index].hidden
                                          ? Container()
                                          : Column(
                                              children: const [
                                                SizedBox(height: 16.0),
                                                SeparatorWidget()
                                              ],
                                            ),
                                      Row(children: [
                                        Expanded(
                                            child: ListView(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0),
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: [
                                              /// POSITION
                                              Text(
                                                  widget.dealProcesses[index]
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: HexColors.black,
                                                      fontFamily:
                                                          'PT Root UI')),
                                              const SizedBox(height: 6.0),

                                              /// POSITION STATUS
                                              Row(children: [
                                                StatusWidget(
                                                    title: widget
                                                        .dealProcesses[index]
                                                        .status,
                                                    status: 0)
                                              ])
                                            ])),
                                        const SizedBox(width: 10.0),

                                        /// MORE BUTTON
                                        SortObjectButtonWidget(
                                            title: '',
                                            imagePath:
                                                'assets/ic_more_vertical.svg',
                                            onTap: () => widget.onMenuTap(
                                                widget.dealProcesses[index]))
                                      ])
                                    ]),
                                onTap: () => widget
                                    .onProcessTap(widget.dealProcesses[index]),
                              );
                      })
                  : Container(),

              /// ADD PROCESS BUTTON
              widget.isExpanded
                  ? widget.onAddProcessTap == null
                      ? widget.dealProcesses.isEmpty
                          ? Container()
                          : Container()
                      : BorderButtonWidget(
                          title: Titles.addProcess,
                          margin: const EdgeInsets.only(top: 16.0),
                          onTap: () => widget.onAddProcessTap!())
                  : Container()
            ]));
  }
}
