import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter/analytics_actions_filter_screen.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_search/analytics_actions_filter_search_screen.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';

class AnalyticsActionsFilterPageViewWidget extends StatefulWidget {
  final VoidCallback onApplyTap;
  final VoidCallback onResetTap;

  const AnalyticsActionsFilterPageViewWidget(
      {Key? key, required this.onApplyTap, required this.onResetTap})
      : super(key: key);

  @override
  _AnalyticsActionsFilterPageViewState createState() =>
      _AnalyticsActionsFilterPageViewState();
}

class _AnalyticsActionsFilterPageViewState
    extends State<AnalyticsActionsFilterPageViewWidget> {
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  bool _isSearching = false;
  bool _isDateSelection = false;

  DateTime _pickedDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime _minDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year -
          5,
      1,
      1);

  final DateTime _maxDateTime = DateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .year +
          5,
      1,
      1);

  @override
  void initState() {
    _pages = [
      AnalyticsActionsFilterScreenWidget(
          onFilialTap: () => {
                setState(() => _isSearching = true),
                _pages.add(AnalyticsActionsFilterSearchScreen(
                    isFilialSearch: true,
                    onPop: () => {
                          setState(() => _isSearching = false),
                          _pageController
                              .animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn)
                              .then((value) =>
                                  {if (mounted) _pages.removeLast()}),
                          Future.delayed(
                              const Duration(milliseconds: 100),
                              () => _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn))
                        })),
              },
          onManagerTap: () => {
                setState(() => _isSearching = true),
                _pages.add(AnalyticsActionsFilterSearchScreen(
                    isFilialSearch: false,
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
          onFromDateTap: () => showDateTimeSelectionSheet(),
          onToDateTap: () => showDateTimeSelectionSheet(),
          onApplyTap: widget.onApplyTap,
          onResetTap: widget.onResetTap),
    ];

    super.initState();
  }

  void showDateTimeSelectionSheet() {
    setState(() => {
          _isDateSelection = true,
          _pages.add(DateTimeWheelPickerWidget(
              minDateTime: _minDateTime,
              maxDateTime: _maxDateTime,
              initialDateTime: _pickedDateTime,
              showDays: true,
              hideDismissIndicator: true,
              locale: locale,
              backgroundColor: HexColors.white,
              buttonColor: HexColors.primaryMain,
              buttonHighlightColor: HexColors.primaryDark,
              buttonTitle: Titles.apply,
              buttonTextStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'PT Root UI',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: HexColors.black),
              selecteTextStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'PT Root UI',
                  fontSize: 14.0,
                  color: HexColors.black,
                  fontWeight: FontWeight.w400),
              unselectedTextStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: 'PT Root UI',
                  fontSize: 12.0,
                  color: HexColors.grey70,
                  fontWeight: FontWeight.w400),
              onTap: (dateTime) => {
                    setState(() => {
                          _isDateSelection = false,
                          _pickedDateTime = dateTime,
                        }),
                    _pageController
                        .animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn)
                        .then((value) => {if (mounted) _pages.removeLast()})
                  }))
        });

    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
                      : _isDateSelection
                          ? 324.0
                          : MediaQuery.of(context).padding.bottom == 0.0
                              ? 400.0
                              : 440.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ))
            ]));
  }
}
