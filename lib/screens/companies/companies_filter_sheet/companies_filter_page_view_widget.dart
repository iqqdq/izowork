import 'package:flutter/material.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter/companies_filter_screen.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_search/companies_filter_search_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';

class CompaniesFilterPageViewWidget extends StatefulWidget {
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const CompaniesFilterPageViewWidget(
      {Key? key, required this.onApplyTap, required this.onResetTap})
      : super(key: key);

  @override
  _CompaniesFilterPageViewState createState() =>
      _CompaniesFilterPageViewState();
}

class _CompaniesFilterPageViewState
    extends State<CompaniesFilterPageViewWidget> {
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  bool _isSearching = false;

  @override
  void initState() {
    _pages = [
      CompaniesFilterScreenWidget(
          onManagerTap: () => {
                setState(() => {
                      _isSearching = true,
                      _pages.add(CompaniesFilterSearchScreenWidget(
                          onPop: () => {
                                setState(() => _isSearching = false),
                                _pageController
                                    .animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn)
                                    .then((value) =>
                                        {if (mounted) _pages.removeLast()})
                              }))
                    }),
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn)
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
                      : 372.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ))
            ]));
  }
}
