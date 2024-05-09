import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';

class ObjectStageListItemWidget extends StatelessWidget {
  final String title;
  final int effectivenes;
  final int readiness;
  final bool showSeparator;
  final VoidCallback? onTap;

  const ObjectStageListItemWidget(
      {Key? key,
      required this.title,
      required this.effectivenes,
      required this.readiness,
      required this.showSeparator,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(
        color: HexColors.black, fontSize: 14.0, fontFamily: 'PT Root UI');
    return Material(
        color: Colors.transparent,
        child: InkWell(
            highlightColor:
                onTap == null ? Colors.transparent : HexColors.grey20,
            splashColor: Colors.transparent,
            onTap: () => onTap == null ? null : onTap!(),
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.only(left: 16.0, top: 12.0, right: 10.0),
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      /// PHASE
                      Expanded(child: Text(title, style: _textStyle)),

                      /// EFFECTIVENESS
                      SizedBox(
                          width: 80.0,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text('$effectivenes %',
                                  textAlign: TextAlign.center,
                                  style: _textStyle))),

                      SizedBox(
                          width: 80.0,
                          child: Row(children: [
                            /// READINESS
                            Expanded(
                                child: Text('$readiness %',
                                    textAlign: onTap == null
                                        ? TextAlign.center
                                        : TextAlign.end,
                                    style: _textStyle)),

                            onTap == null
                                ? Container()
                                : SvgPicture.asset('assets/ic_arrow_right.svg')
                          ]))
                    ],
                  ),
                  const SizedBox(height: 14.0),
                  showSeparator ? const SeparatorWidget() : Container()
                ])));
  }
}
