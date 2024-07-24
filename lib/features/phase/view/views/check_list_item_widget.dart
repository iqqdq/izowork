import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/extensions/extensions.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/checkbox_widget.dart';
import 'package:izowork/views/status_widget.dart';

class CheckListItemWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final DateTime? deadline;
  final String? state;
  final VoidCallback onTap;
  final Function(Widget) onStatusTap;
  final VoidCallback? onRemoveTap;

  const CheckListItemWidget({
    Key? key,
    required this.isSelected,
    required this.title,
    this.deadline,
    this.state,
    required this.onTap,
    required this.onStatusTap,
    this.onRemoveTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusWidget = StatusWidget(
      title: state == PhaseChecklistState.underReview
          ? 'На проверке'
          : state == PhaseChecklistState.rejected
              ? 'Отклонен'
              : 'Принят',
      status: state == PhaseChecklistState.underReview
          ? 0
          : state == PhaseChecklistState.rejected
              ? 3
              : state == PhaseChecklistState.accepted
                  ? 2
                  : 3,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        child: Container(
          constraints: const BoxConstraints(minHeight: 36.0),
          child: Row(children: [
            CheckBoxWidget(isSelected: isSelected),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                deadline == null
                    ? title
                    : '$title\n(${Titles.until} ${deadline!.toShortDate()})',
                style: TextStyle(
                  color: HexColors.black,
                  fontSize: 16.0,
                  fontFamily: 'PT Root UI',
                ),
              ),
            ),
            state == PhaseChecklistState.created
                ? onRemoveTap == null
                    ? Container()
                    : InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: SvgPicture.asset('assets/ic_clear.svg'),
                        onTap: () => onRemoveTap!(),
                      )
                : Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: HexColors.grey10,
                        splashColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.0),
                        child: statusWidget,
                        onTap: () => onStatusTap(statusWidget),
                      ),
                    ),
                  ),
          ]),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
