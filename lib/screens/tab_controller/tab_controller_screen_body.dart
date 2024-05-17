import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:izowork/screens/actions/actions_page_view_screen_body.dart';
import 'package:izowork/screens/chat/chat_screen.dart';
import 'package:izowork/screens/map/map_screen.dart';
import 'package:izowork/screens/more/more_screen.dart';
import 'package:izowork/screens/notifications/notifications_screen.dart';
import 'package:izowork/screens/objects/objects_screen.dart';
import 'package:izowork/screens/tab_controller/views/bottom_navigation_bar_widget.dart';
import 'package:izowork/main.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/services/services.dart';

class TabControllerScreenBodyWidget extends StatefulWidget {
  const TabControllerScreenBodyWidget({Key? key}) : super(key: key);

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
    if (index == 3) {
      _tabControllerViewModel.clearMessageCount();
    }

    if (index == 4) {
      _tabControllerViewModel.clearNotificationCount();
    }

    _index = index;
    _pageController.jumpToPage(_index);
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? event) {
      if (event != null) {
        // final notificationEntity =
        //     NotificationEntity.fromJson(jsonDecode(event));

        // TODO: if chat notification

        _onTabSelected(4).whenComplete(
          () => navigatorKey.currentState?.push(MaterialPageRoute(
              builder: (context) =>
                  NotificationsScreenWidget(onPop: () => {}))),
        );
      }
    });
  }
}
