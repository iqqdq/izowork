import 'package:flutter/material.dart';
import 'package:izowork/api/api.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/views/views.dart';

class PhaseChecklistMessageItemWidget extends StatelessWidget {
  final PhaseChecklistMessage phaseChecklistMessage;
  final VoidCallback onUserTap;

  const PhaseChecklistMessageItemWidget({
    Key? key,
    required this.phaseChecklistMessage,
    required this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _url = phaseChecklistMessage.user.avatar;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      color: HexColors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          child: Row(children: [
            ///  AVATAR
            AvatarWidget(
              url: avatarUrl,
              endpoint: _url,
              size: 30.0,
            ),
            const SizedBox(width: 12.0),

            /// USER NAME
            Expanded(
              child: Text(
                phaseChecklistMessage.user.name,
                maxLines: 1,
                style: TextStyle(
                  color: HexColors.grey50,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI',
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ]),
          onTap: () => onUserTap(),
        ),
        const SizedBox(height: 12.0),

        /// MESSAGE
        SelectionArea(
          child: Text(phaseChecklistMessage.body,
              style: TextStyle(
                color: HexColors.black,
                fontSize: 14.0,
                fontFamily: 'PT Root UI',
                fontWeight: FontWeight.w400,
              )),
        ),
        const SizedBox(height: 8.0),

        /// DATE
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TitleWidget(
              text: DateTimeFormatter().formatDateTimeToString(
                dateTime: phaseChecklistMessage.createdAt,
                showTime: true,
                showMonthName: true,
              ),
              padding: EdgeInsets.zero,
              textAlign: TextAlign.end,
              isSmall: true,
            ),
          ],
        )
      ]),
    );
  }
}
