import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/views/badge_widget.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int index;
  final int messageCount;
  final int notificationCount;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.index,
    required this.messageCount,
    required this.notificationCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: HexColors.grey40,
      fontSize: 12.0,
      fontFamily: 'PT Root UI',
      fontWeight: FontWeight.w500,
    );

    return BottomNavigationBar(
      selectedLabelStyle: textStyle.copyWith(color: HexColors.primaryMain),
      unselectedLabelStyle: textStyle,
      fixedColor: HexColors.primaryMain,
      unselectedItemColor: HexColors.grey40,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        /// MAP
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
              index == 0 ? 'assets/ic_map_selected.svg' : 'assets/ic_map.svg'),
          label: Titles.map,
        ),

        /// OBJECTS
        BottomNavigationBarItem(
          icon: SvgPicture.asset(index == 1
              ? 'assets/ic_objects_selected.svg'
              : 'assets/ic_objects.svg'),
          label: Titles.objects,
        ),

        /// ACTIONS
        BottomNavigationBarItem(
          icon: SvgPicture.asset(index == 2
              ? 'assets/ic_actions_selected.svg'
              : 'assets/ic_actions.svg'),
          label: Titles.myDoing,
        ),

        /// CHAT
        BottomNavigationBarItem(
          icon: BadgeWidget(
            value: messageCount,
            child: SvgPicture.asset(index == 3
                ? 'assets/ic_chat_selected.svg'
                : 'assets/ic_chat.svg'),
          ),
          label: Titles.chat,
        ),

        /// MORE
        BottomNavigationBarItem(
          icon: BadgeWidget(
            value: notificationCount,
            child: SvgPicture.asset(
              index == 4 ? 'assets/ic_more_selected.svg' : 'assets/ic_more.svg',
            ),
          ),
          label: Titles.more,
        ),
      ],
      currentIndex: index,
      onTap: (index) => onTap(index),
    );
  }
}
