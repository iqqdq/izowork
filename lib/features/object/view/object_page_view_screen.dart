import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/features/object/view/object_page/object_page_screen.dart';
import 'package:izowork/features/object/view/object_actions/object_actions_screen.dart';
import 'package:izowork/views/views.dart';

class ObjectPageViewScreenWidget extends StatefulWidget {
  final String id;
  final String? phaseId;
  final Function(MapObject?) onPop;

  const ObjectPageViewScreenWidget({
    Key? key,
    required this.id,
    this.phaseId,
    required this.onPop,
  }) : super(key: key);

  @override
  _ObjectPageViewScreenState createState() => _ObjectPageViewScreenState();
}

class _ObjectPageViewScreenState extends State<ObjectPageViewScreenWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget>? _pages;
  int _index = 0;

  MapObject? _object;

  @override
  void initState() {
    _pages = [
      ObjectPageScreenWidget(
        id: widget.id,
        phaseId: widget.phaseId,
        onPop: (object) => _object = object,
      ),
      ObjectActionsScreenWidget(
        id: widget.id,
        onObjectTraceTap: () => {
          setState(() => _index = 0),
          _pageController.animateToPage(
            _index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          )
        },
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.onPop(_object);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
          toolbarHeight: 64.0,
          titleSpacing: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: HexColors.white,
          automaticallyImplyLeading: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: BackButtonWidget(onTap: () => Navigator.pop(context)),
            ),

            /// SEGMENTED CONTROL
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SegmentedControlWidget(
                  titles: const [
                    Titles.object,
                    Titles.actions,
                  ],
                  initialIndex: _index,
                  width: MediaQuery.of(context).size.width - 40.0,
                  backgroundColor: HexColors.grey10,
                  activeColor: HexColors.black,
                  disableColor: HexColors.grey40,
                  thumbColor: HexColors.white,
                  borderColor: HexColors.grey20,
                  onTap: (index) => {
                        FocusScope.of(context).unfocus(),
                        setState(() => _index = index),
                        _pageController.animateToPage(
                          _index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                        )
                      }),
            )
          ]),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages ?? [],
          onPageChanged: (page) => setState(() => _index = page),
        ));
  }
}
