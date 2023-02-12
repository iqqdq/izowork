import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/actions/actions_page_view_screen_body.dart';
import 'package:izowork/screens/chat/chat_screen.dart';
import 'package:izowork/screens/map/map_screen.dart';
import 'package:izowork/screens/more/more_screen.dart';
import 'package:izowork/screens/objects/objects_screen.dart';

class TabControllerScreenWidget extends StatefulWidget {
  const TabControllerScreenWidget({Key? key}) : super(key: key);

  @override
  _TabControllerScreenState createState() => _TabControllerScreenState();
}

class _TabControllerScreenState extends State<TabControllerScreenWidget> {
  final PageController? _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  @override
  void initState() {
    _pages = [
      const MapScreenWidget(),
      const ObjectsScreenWidget(),
      const ActionsPageViewScreenWidget(),
      const ChatScreenWidget(),
      const MoreScreenWidget()
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
        body: PageView(
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
              BottomNavigationBarItem(
                  icon: Image.asset(_index == 0
                      ? 'assets/ic_map_selected.png'
                      : 'assets/ic_map.png'),
                  label: Titles.map),
              BottomNavigationBarItem(
                  icon: Image.asset(_index == 1
                      ? 'assets/ic_objects_selected.png'
                      : 'assets/ic_objects.png'),
                  label: Titles.objects),
              BottomNavigationBarItem(
                  icon: Image.asset(_index == 2
                      ? 'assets/ic_actions_selected.png'
                      : 'assets/ic_actions.png'),
                  label: Titles.myDoing),
              BottomNavigationBarItem(
                  icon: Image.asset(_index == 3
                      ? 'assets/ic_chat_selected.png'
                      : 'assets/ic_chat.png'),
                  label: Titles.chat),
              BottomNavigationBarItem(
                  icon: Image.asset(_index == 4
                      ? 'assets/ic_more_selected.png'
                      : 'assets/ic_more.png'),
                  label: Titles.more)
            ],
            currentIndex: _index,
            onTap: (index) => setState(() {
                  _index = index;
                  _pageController?.jumpToPage(_index);
                })));
  }
}
