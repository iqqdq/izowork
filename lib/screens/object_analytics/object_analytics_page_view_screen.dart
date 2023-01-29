import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/screens/object_analytics/object_analytics/object_analytics_screen.dart';
import 'package:izowork/screens/object_analytics/object_analytics_actions/object_analytics_actions_screen.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/segmented_control_widget.dart';

class ObjectAnalyticsPageViewScreenBodyWidget extends StatefulWidget {
  const ObjectAnalyticsPageViewScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ObjectAnalyticsPageViewScreenBodyState createState() =>
      _ObjectAnalyticsPageViewScreenBodyState();
}

class _ObjectAnalyticsPageViewScreenBodyState
    extends State<ObjectAnalyticsPageViewScreenBodyWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  @override
  void initState() {
    _pages = [
      const ObjectAnalyticsScreenWidget(),
      const ObjectAnalyticsActionsScreenWidget()
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
            toolbarHeight: 112.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              const SizedBox(height: 12.0),
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.analytics,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 20.0),

              /// SEGMENTED CONTROL
              SegmentedControlWidget(
                  titles: const [Titles.object, Titles.actions],
                  backgroundColor: HexColors.grey10,
                  activeColor: HexColors.black,
                  disableColor: HexColors.grey40,
                  thumbColor: HexColors.white,
                  borderColor: HexColors.grey20,
                  onTap: (index) => {
                        FocusScope.of(context).unfocus(),
                        setState(() => _index = index),
                        _pageController.animateToPage(_index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn)
                      }),
              const SizedBox(height: 16.0)
            ])),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages!,
          onPageChanged: (page) => setState(() => _index = page),
        ));
  }
}
