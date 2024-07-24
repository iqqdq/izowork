import 'package:flutter/material.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/features/deals/view/deals_screen.dart';
import 'package:izowork/features/tasks/view/tasks_screen.dart';
import 'package:izowork/views/views.dart';

class ActionsPageViewScreenWidget extends StatefulWidget {
  const ActionsPageViewScreenWidget({Key? key}) : super(key: key);

  @override
  _ActionsPageViewScreenState createState() => _ActionsPageViewScreenState();
}

class _ActionsPageViewScreenState extends State<ActionsPageViewScreenWidget>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: HexColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        backgroundColor: HexColors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 10.0),

          /// SEGMENTED CONTROL
          SegmentedControlWidget(
              titles: const [Titles.deals, Titles.tasks],
              backgroundColor: HexColors.grey10,
              activeColor: HexColors.black,
              disableColor: HexColors.grey40,
              thumbColor: HexColors.white,
              borderColor: HexColors.grey20,
              onTap: (index) => {
                    FocusScope.of(context).unfocus(),
                    _pageController.jumpToPage(index)
                  }),
        ]),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            DealsScreenWidget(),
            TasksScreenWidget(),
          ],
        ),
      ),
    );
  }
}
