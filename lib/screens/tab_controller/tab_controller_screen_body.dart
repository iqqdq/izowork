import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/screens/deal/deal_screen.dart';
import 'package:izowork/screens/dialog/dialog_screen.dart';
import 'package:izowork/screens/news_page/news_page_screen.dart';
import 'package:izowork/screens/object/object_page_view_screen.dart';
import 'package:izowork/screens/tab_controller/tab_controller_screen.dart';
import 'package:izowork/screens/task/task_screen.dart';
import 'package:provider/provider.dart';

import 'package:izowork/screens/actions/actions_page_view_screen_body.dart';
import 'package:izowork/screens/chat/chat_screen.dart';
import 'package:izowork/screens/map/map_screen.dart';
import 'package:izowork/screens/more/more_screen.dart';
import 'package:izowork/screens/objects/objects_screen.dart';
import 'package:izowork/screens/tab_controller/views/bottom_navigation_bar_widget.dart';
import 'package:izowork/main.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/services/services.dart';

class TabControllerScreenBodyWidget extends StatefulWidget {
  const TabControllerScreenBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TabControllerScreenBodyState createState() =>
      _TabControllerScreenBodyState();
}

class _TabControllerScreenBodyState
    extends State<TabControllerScreenBodyWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  late TabControllerViewModel _tabControllerViewModel;

  final List<Widget>? _pages = [
    const MapScreenWidget(),
    const ObjectsScreenWidget(),
    const ActionsPageViewScreenWidget(),
    const ChatScreenWidget(),
    const MoreScreenWidget()
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _configureSelectNotificationSubject();

    FirebaseMessagingService(
      onTokenReceive: (token) => _tabControllerViewModel.updateFcmToken(token),
      onNotificationRecieve: (notification) =>
          selectNotificationStream.add(jsonEncode(notification.data)),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    selectNotificationStream.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabControllerViewModel = Provider.of<TabControllerViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages!,
        onPageChanged: (page) => setState(() => _index = page),
      ),
      bottomNavigationBar: _pages?.length == 4
          ? Container()
          : BottomNavigationBarWidget(
              index: _index,
              messageCount: _tabControllerViewModel.messageCount,
              notificationCount: _tabControllerViewModel.notificationCount,
              onTap: (index) => _onTabSelected(index),
            ),
    );
  }

  Future _onTabSelected(int index) async {
    if (index == 3) _tabControllerViewModel.clearMessageCount();
    if (index == 4) _tabControllerViewModel.clearNotificationCount();

    _index = index;
    _pageController.jumpToPage(_index);
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? event) async {
      if (event != null) {
        final notificationEntity =
            NotificationEntity.fromJson(jsonDecode(event));

        /// CHECK IF CURRENT WIDGET IS ROOT
        if (navigatorKey.currentWidget == const TabControllerScreenWidget()) {
          _pushFromNotification(notificationEntity);
        } else {
          /// IF IT'S NOT -> GO TO ROOT THEN PUSH
          navigatorKey.currentState?.popUntil((route) => route.isFirst);
          Future.delayed(const Duration(milliseconds: 300),
              () => _pushFromNotification(notificationEntity));
        }
      }
    });
  }

  void _pushFromNotification(NotificationEntity notificationEntity) {
    if (notificationEntity.metadata.objectId != null) {
      _onTabSelected(1).whenComplete(
        () => navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => ObjectPageViewScreenWidget(
                  id: notificationEntity.metadata.objectId!,
                  phaseId: notificationEntity.metadata.phaseId,
                ))),
      );
    } else if (notificationEntity.metadata.dealId != null) {
      _onTabSelected(2).whenComplete(
        () => navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) =>
                DealScreenWidget(id: notificationEntity.metadata.dealId!))),
      );
    } else if (notificationEntity.metadata.taskId != null) {
      _onTabSelected(2).whenComplete(
        () => navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) =>
                TaskScreenWidget(id: notificationEntity.metadata.taskId!))),
      );
    } else if (notificationEntity.metadata.newsId != null) {
      _onTabSelected(4).whenComplete(
        () => navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) =>
                NewsPageScreenWidget(id: notificationEntity.metadata.newsId!))),
      );
    } else if (notificationEntity.metadata.chatId != null) {
      _onTabSelected(3).whenComplete(
        () => navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => DialogScreenWidget(
                  id: notificationEntity.metadata.chatId!,
                ))),
      );
    }

    //  _onTabSelected(4).whenComplete(
    //       () => navigatorKey.currentState?.push(MaterialPageRoute(
    //           builder: (context) =>
    //               NotificationsScreenWidget(onPop: () => {}))),
    //     );
  }
}
