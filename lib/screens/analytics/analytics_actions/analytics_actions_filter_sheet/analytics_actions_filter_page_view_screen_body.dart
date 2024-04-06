import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/locale.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/office.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/analytics_actions_filter_view_model.dart';
import 'package:izowork/screens/search_office/search_office_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/views/date_time_wheel_picker_widget.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:izowork/screens/analytics/analytics_actions/analytics_actions_filter_sheet/analytics_actions_filter_screen_body.dart';
import 'package:provider/provider.dart';

class AnalyticsActionsFilter {
  final Office? office;
  final User? user;
  final DateTime? fromDateTime;
  final DateTime? toDateTime;
  final List<String> params;

  AnalyticsActionsFilter(
      this.office, this.user, this.fromDateTime, this.toDateTime, this.params);
}

class AnalyticsActionsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(AnalyticsActionsFilter?) onPop;

  const AnalyticsActionsFilterPageViewScreenBodyWidget(
      {Key? key, required this.onPop})
      : super(key: key);

  @override
  _AnalyticsActionsFilterPageViewScreenBodyState createState() =>
      _AnalyticsActionsFilterPageViewScreenBodyState();
}

class _AnalyticsActionsFilterPageViewScreenBodyState
    extends State<AnalyticsActionsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late AnalyticsActionsFilterViewModel _analyticsActionsFilterViewModel;
  bool _isFromDateTimeSelection = true;
  // bool _isSearching = false;
  bool _isDateTimeSelection = false;

  @override
  Widget build(BuildContext context) {
    _analyticsActionsFilterViewModel =
        Provider.of<AnalyticsActionsFilterViewModel>(
      context,
      listen: true,
    );

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
                  height: _isDateTimeSelection
                      ? MediaQuery.of(context).padding.bottom == 0.0
                          ? 304.0
                          : 324.0
                      : MediaQuery.of(context).size.height * 0.9,
                  // _isSearching
                  //     ? MediaQuery.of(context).size.height * 0.9
                  //     : MediaQuery.of(context).padding.bottom == 0.0
                  //         ? 410.0
                  //         : 440.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AnalyticsActionsFilterScreenBodyWidget(
                          office: _analyticsActionsFilterViewModel.office,
                          manager: _analyticsActionsFilterViewModel.user,
                          fromDateTime:
                              _analyticsActionsFilterViewModel.fromDateTime,
                          toDateTime:
                              _analyticsActionsFilterViewModel.toDateTime,
                          onOfficeTap: () => {
                                // setState(() => _isSearching = true),
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onManagerTap: () => {
                                // setState(() => _isSearching = true),
                                _pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onFromDateTimeTap: () => {
                                setState(() => {
                                      _isDateTimeSelection = true,
                                      _isFromDateTimeSelection = true
                                    }),
                                _pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onToDateTimeTap: () => {
                                setState(() => {
                                      _isDateTimeSelection = true,
                                      _isFromDateTimeSelection = false
                                    }),
                                _pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onApplyTap: () => {
                                _analyticsActionsFilterViewModel
                                    .apply((params) => {
                                          widget.onPop(AnalyticsActionsFilter(
                                              _analyticsActionsFilterViewModel
                                                  .office,
                                              _analyticsActionsFilterViewModel
                                                  .user,
                                              _analyticsActionsFilterViewModel
                                                  .fromDateTime,
                                              _analyticsActionsFilterViewModel
                                                  .toDateTime,
                                              params)),
                                          Navigator.pop(context)
                                        })
                              },
                          onResetTap: () =>
                              _analyticsActionsFilterViewModel.reset(() => {
                                    widget.onPop(null),
                                    Navigator.pop(context)
                                  })),

                      /// OFFICE SELECTION
                      SearchOfficeScreenWidget(
                          title: Titles.filial,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (office) => {
                                _analyticsActionsFilterViewModel
                                    .setOffice(office)
                                    .then((value) => {
                                          _pageController.animateToPage(
                                            0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          ),
                                          // setState(() => _isSearching = false),
                                        })
                              }),

                      /// MANAGER SELECTION
                      SearchUserScreenWidget(
                          title: Titles.manager,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (user) => {
                                _analyticsActionsFilterViewModel
                                    .setUser(user)
                                    .then((value) => {
                                          _pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn),
                                          // setState(() => _isSearching = false),
                                        })
                              }),

                      /// DATE SELECTION
                      DateTimeWheelPickerWidget(
                          minDateTime:
                              _analyticsActionsFilterViewModel.minDateTime,
                          maxDateTime:
                              _analyticsActionsFilterViewModel.maxDateTime,
                          initialDateTime: (_isFromDateTimeSelection
                                  ? _analyticsActionsFilterViewModel
                                      .fromDateTime
                                  : _analyticsActionsFilterViewModel
                                      .toDateTime) ??
                              DateTime.now(),
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
                                if (_isFromDateTimeSelection)
                                  {
                                    _analyticsActionsFilterViewModel
                                        .setFromDateTime(dateTime)
                                        .then((value) => {
                                              _pageController.animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeIn),
                                              setState(() =>
                                                  _isDateTimeSelection = false)
                                            })
                                  }
                                else
                                  {
                                    _analyticsActionsFilterViewModel
                                        .setToDateTime(dateTime)
                                        .then((value) => {
                                              _pageController.animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeIn),
                                              setState(() =>
                                                  _isDateTimeSelection = false)
                                            })
                                  }
                              })
                    ],
                  ))
            ]));
  }
}
