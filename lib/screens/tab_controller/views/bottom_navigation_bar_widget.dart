import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';

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
          icon: Badge(
            backgroundColor: HexColors.additionalViolet,
            label: Text(
                messageCount.toString().length > 4
                    ? messageCount.toString().substring(0, 3)
                    : messageCount.toString(),
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: HexColors.white,
                )),
            isLabelVisible: messageCount > 0,
            child: SvgPicture.asset(index == 3
                ? 'assets/ic_chat_selected.svg'
                : 'assets/ic_chat.svg'),
          ),
          label: Titles.chat,
        ),

        /// MORE
        BottomNavigationBarItem(
          icon: Badge(
            backgroundColor: HexColors.additionalViolet,
            label: Text(
                notificationCount.toString().length > 3
                    ? notificationCount.toString().substring(0, 2) + '...'
                    : notificationCount.toString(),
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: HexColors.white,
                )),
            isLabelVisible: notificationCount > 0,
            child: SvgPicture.asset(index == 4
                ? 'assets/ic_more_selected.svg'
                : 'assets/ic_more.svg'),
          ),
          label: Titles.more,
        ),
      ],
      currentIndex: index,
      onTap: (index) => onTap(index),
    );
  }
}
