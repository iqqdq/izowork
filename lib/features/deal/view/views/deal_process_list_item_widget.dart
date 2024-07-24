import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/analytics/view/views/sort_orbject_button_widget.dart';
import 'package:izowork/views/views.dart';

class DealProcessListItemWidget extends StatefulWidget {
  final DealStage dealStage;
  final List<DealProcess> dealProcesses;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(DealProcess) onProcessTap;
  final Function(DealProcess) onMenuTap;
  final VoidCallback? onAddProcessTap;

  const DealProcessListItemWidget(
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
  _DealProcessListItemState createState() => _DealProcessListItemState();
}

class _DealProcessListItemState extends State<DealProcessListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: widget.dealStage.locked ? 0.65 : 1.0,
        child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 1.0, color: HexColors.grey20)),
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: 16.0, bottom: 16.0, right: 16.0),
                shrinkWrap: true,
                children: [
                  /// HEADER
                  InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.only(
                              top: 16.0, bottom: widget.isExpanded ? 4.0 : 0.0),
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/ic_done.svg',
                              colorFilter: widget.dealStage.locked
                                  ? ColorFilter.mode(
                                      HexColors.grey40,
                                      BlendMode.srcIn,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                                child: Text(widget.dealStage.name,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'PT Root UI'))),
                            const SizedBox(width: 12.0),
                            SortObjectButtonWidget(
                                title: '',
                                imagePath: widget.isExpanded
                                    ? 'assets/ic_arrow_up.svg'
                                    : 'assets/ic_arrow_down.svg',
                                onTap: () => widget.onTap())
                          ])),
                      onTap: () => widget.onTap()),

                  /// PROCESS LIST VIEW
                  widget.isExpanded
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.dealProcesses.length,
                          itemBuilder: (context, index) {
                            bool? isCompleted = widget
                                .dealProcesses[index].needConfirmations
                                .map((c) => widget
                                    .dealProcesses[index].confirmations?[c])
                                .reduce((a, c) => a == true && c == true);

                            return widget.dealProcesses[index].hidden == true
                                ? Container()
                                : InkWell(
                                    key: ValueKey(
                                        widget.dealProcesses[index].id),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Column(children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: const SeparatorWidget()),
                                      Row(children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              /// POSITION
                                              Text(
                                                  widget.dealProcesses[index]
                                                      .name,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: HexColors.black,
                                                    fontFamily: 'PT Root UI',
                                                  )),
                                              const SizedBox(height: 6.0),

                                              /// POSITION STATUS
                                              StatusWidget(
                                                  title: widget
                                                      .dealProcesses[index]
                                                      .status,
                                                  textAlign: TextAlign.start,
                                                  status: isCompleted == null
                                                      ? 1
                                                      : isCompleted
                                                          ? 2
                                                          : 1)
                                            ])),
                                        const SizedBox(width: 16.0),

                                        /// MORE BUTTON
                                        widget.dealStage.locked
                                            ? Container()
                                            : SortObjectButtonWidget(
                                                title: '',
                                                imagePath:
                                                    'assets/ic_more_vertical.svg',
                                                onTap: () => widget.onMenuTap(
                                                    widget
                                                        .dealProcesses[index]))
                                      ])
                                    ]),
                                    onTap: () => widget.onProcessTap(
                                        widget.dealProcesses[index]),
                                    //)
                                  );
                          })
                      : Container(),

                  /// ADD PROCESS BUTTON
                  widget.isExpanded
                      ? widget.onAddProcessTap == null
                          ? widget.dealProcesses.isEmpty
                              ? Container()
                              : Container()
                          : IgnorePointer(
                              ignoring: widget.dealStage.locked,
                              child: BorderButtonWidget(
                                  title: Titles.addProcess,
                                  margin: const EdgeInsets.only(top: 16.0),
                                  onTap: () => widget.onAddProcessTap!()))
                      : Container()
                ])));
  }
}
