import 'package:flutter/material.dart';
import 'package:izowork/screens/map/map_filter_sheet/map_filter_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';

class MapFilterPageViewWidget extends StatefulWidget {
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const MapFilterPageViewWidget(
      {Key? key, required this.onApplyTap, required this.onResetTap})
      : super(key: key);

  @override
  _MapFilterPageViewState createState() => _MapFilterPageViewState();
}

class _MapFilterPageViewState extends State<MapFilterPageViewWidget> {
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  bool _isSearching = false;

  @override
  void initState() {
    _pages = [
      MapFilterWidget(
          onDeveloperTap: () => {
                // setState(() => _isSearching = true),
                // _pageController.animateToPage(_pages.length,
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeIn)
              },
          onManagerTap: () => {
                // setState(() => _isSearching = true),
                // _pageController.animateToPage(_pages.length,
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeIn)
              },
          onApplyTap: widget.onApplyTap,
          onResetTap: widget.onResetTap),
      Container()
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              /// DISMISS INDICATOR
              const SizedBox(height: 6.0),
              const DismissIndicatorWidget(),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSearching
                      ? MediaQuery.of(context).size.height * 0.7
                      : 480.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ))
            ]));
  }
}
