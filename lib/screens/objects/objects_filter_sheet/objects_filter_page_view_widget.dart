import 'package:flutter/material.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter/objects_filter_screen.dart';
import 'package:izowork/screens/search/search_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';

class ObjectsFilterPageViewWidget extends StatefulWidget {
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const ObjectsFilterPageViewWidget(
      {Key? key, required this.onApplyTap, required this.onResetTap})
      : super(key: key);

  @override
  _ObjectsFilterPageViewState createState() => _ObjectsFilterPageViewState();
}

class _ObjectsFilterPageViewState extends State<ObjectsFilterPageViewWidget> {
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  bool _isSearching = false;

  @override
  void initState() {
    _pages = [
      ObjectsFilterScreenWidget(
          onDeveloperTap: () => {
                setState(() => _isSearching = true),
                _pages.add(SearchScreenWidget(
                    isRoot: false,
                    searchType: SearchType.developer,
                    onPop: () => {
                          setState(() => _isSearching = false),
                          _pageController
                              .animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn)
                              .then(
                                  (value) => {if (mounted) _pages.removeLast()})
                        })),
                Future.delayed(
                    const Duration(milliseconds: 100),
                    () => _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn))
              },
          onManagerTap: () => {
                setState(() => _isSearching = true),
                _pages.add(SearchScreenWidget(
                    isRoot: false,
                    searchType: SearchType.manager,
                    onPop: () => {
                          setState(() => _isSearching = false),
                          _pageController
                              .animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn)
                              .then(
                                  (value) => {if (mounted) _pages.removeLast()})
                        })),
                Future.delayed(
                    const Duration(milliseconds: 100),
                    () => _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn))
              },
          onApplyTap: widget.onApplyTap,
          onResetTap: widget.onResetTap),
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
                      : MediaQuery.of(context).padding.bottom == 0.0
                          ? 450.0
                          : 470.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ))
            ]));
  }
}
