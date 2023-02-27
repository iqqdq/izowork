import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/views/checkbox_widget.dart';
import 'package:izowork/views/status_widget.dart';

class CheckListItemWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String? state;
  final VoidCallback onTap;

  const CheckListItemWidget(
      {Key? key,
      required this.isSelected,
      required this.title,
      this.state,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
          child: Row(children: [
            CheckBoxWidget(isSelected: isSelected),
            const SizedBox(width: 8.0),
            Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 16.0,
                        fontFamily: 'PT Root UI'))),
            state == null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: StatusWidget(
                        title: state!,
                        status:
                            state == 'UNDER_REVIEW' || state == 'На проверке'
                                ? 0
                                : state == 'Принят'
                                    ? 1
                                    : state == 'NEW' || state == 'Новый'
                                        ? 2
                                        : 3))
          ]),
          onTap: () => onTap()),
    );
  }
}
