import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/views/views.dart';
import 'analytics_companies/analytics_companies_screen.dart';
import 'analytics_objects/analytics_objects_screen.dart';
import 'analytics_actions/analytics_actions_screen.dart';

class AnalyticsPageViewScreenBodyWidget extends StatefulWidget {
  const AnalyticsPageViewScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _AnalyticsPageViewScreenBodyState createState() =>
      _AnalyticsPageViewScreenBodyState();
}

class _AnalyticsPageViewScreenBodyState
    extends State<AnalyticsPageViewScreenBodyWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  @override
  void initState() {
    _pages = [
      const AnalyticsCompaniesScreenWidget(),
      const AnalyticsObjectsScreenWidget(),
      const AnalyticsActionsScreenWidget(),
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
                  titles: const [
                    Titles.companies,
                    Titles.objects,
                    Titles.actions
                  ],
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
              const SizedBox(height: 16.0),
              const SeparatorWidget()
            ])),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages!,
          onPageChanged: (page) => setState(() => _index = page),
        ));
  }
}
