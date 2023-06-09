// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/tab_controller_view_model.dart';
import 'package:izowork/screens/actions/actions_page_view_screen_body.dart';
import 'package:izowork/screens/chat/chat_screen.dart';
import 'package:izowork/screens/map/map_screen.dart';
import 'package:izowork/screens/more/more_screen.dart';
import 'package:izowork/screens/objects/objects_screen.dart';
import 'package:izowork/views/badge_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class TabControllerScreenBodyWidget extends StatefulWidget {
  const TabControllerScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _TabControllerScreenBodyState createState() =>
      _TabControllerScreenBodyState();
}

class _TabControllerScreenBodyState
    extends State<TabControllerScreenBodyWidget> {
  final PageController? _pageController = PageController(initialPage: 0);
  late List<Widget>? _pages;
  int _index = 0;

  late TabControllerViewModel _tabControllerViewModel;

  @override
  void initState() {
    _pages = [
      const MapScreenWidget(),
      const ObjectsScreenWidget(),
      const ActionsPageViewScreenWidget(),
      const ChatScreenWidget()
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabControllerViewModel =
        Provider.of<TabControllerViewModel>(context, listen: true);

    if (_tabControllerViewModel.loadingStatus == LoadingStatus.completed &&
        _pages?.length == 4) {
      _pages?.add(
          MoreScreenWidget(count: _tabControllerViewModel.notificationCount));
    }

    final textStyle = TextStyle(
        color: HexColors.grey40,
        fontSize: 12.0,
        fontFamily: 'PT Root UI',
        fontWeight: FontWeight.w500);

    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            toolbarHeight: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark),
        body: _pages?.length == 4
            ? const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: LoadingIndicatorWidget()))
            : PageView(
                controller: _pageController,
                physics: _index == 0
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                children: _pages!,
                onPageChanged: (page) => setState(() => _index = page),
              ),
        bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle:
                textStyle.copyWith(color: HexColors.primaryMain),
            unselectedLabelStyle: textStyle,
            fixedColor: HexColors.primaryMain,
            unselectedItemColor: HexColors.grey40,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              /// MAP
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(_index == 0
                      ? 'assets/ic_map_selected.svg'
                      : 'assets/ic_map.svg'),
                  label: Titles.map),

              /// OBJECTS
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(_index == 1
                      ? 'assets/ic_objects_selected.svg'
                      : 'assets/ic_objects.svg'),
                  label: Titles.objects),

              /// ACTIONS
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(_index == 2
                      ? 'assets/ic_actions_selected.svg'
                      : 'assets/ic_actions.svg'),
                  label: Titles.myDoing),

              /// CHAT
              BottomNavigationBarItem(
                  icon: Stack(
                      alignment: _tabControllerViewModel.messageCount > 0
                          ? AlignmentDirectional.topEnd
                          : AlignmentDirectional.center,
                      children: [
                        SvgPicture.asset(_index == 3
                            ? 'assets/ic_chat_selected.svg'
                            : 'assets/ic_chat.svg'),
                        BadgeWidget(
                            radius: 8.0,
                            value: _tabControllerViewModel.messageCount)
                      ]),
                  label: Titles.chat),

              /// MORE
              BottomNavigationBarItem(
                  icon: Stack(
                      alignment: _tabControllerViewModel.notificationCount > 0
                          ? AlignmentDirectional.topEnd
                          : AlignmentDirectional.center,
                      children: [
                        SvgPicture.asset(_index == 4
                            ? 'assets/ic_more_selected.svg'
                            : 'assets/ic_more.svg'),
                        BadgeWidget(
                            radius: 8.0,
                            value: _tabControllerViewModel.notificationCount)
                      ]),
                  label: Titles.more)
            ],
            currentIndex: _index,
            onTap: (index) => setState(() {
                  switch (index) {
                    case 3:
                      _tabControllerViewModel.clearMessageBadge();
                      break;
                    case 4:
                      _tabControllerViewModel.clearNotificationBadge();
                      break;
                    default:
                  }

                  _index = index;
                  _pageController?.jumpToPage(_index);
                })));
  }
}
