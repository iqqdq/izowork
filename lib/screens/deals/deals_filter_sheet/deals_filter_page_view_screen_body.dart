import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/domain.dart';
import 'package:izowork/screens/deals/deals_filter_sheet/deals_filter_screen.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_object/search_object_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class DealsFilter {
  final User? responsible;
  final MapObject? object;
  final Company? company;
  final List<int> tags;
  final List<String> params;

  DealsFilter(
      this.responsible, this.object, this.company, this.tags, this.params);
}

class DealsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(DealsFilter?) onPop;

  const DealsFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _DealsFilterPageViewScreenBodyState createState() =>
      _DealsFilterPageViewScreenBodyState();
}

class _DealsFilterPageViewScreenBodyState
    extends State<DealsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late DealsFilterViewModel _dealsFilterViewModel;

  // bool _isSearching = false;
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    _dealsFilterViewModel = Provider.of<DealsFilterViewModel>(
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
                  height: MediaQuery.of(context).size.height * 0.9,
                  // _isSearching
                  // ? MediaQuery.of(context).size.height * 0.9
                  // : MediaQuery.of(context).padding.bottom == 0.0
                  //     ? 410.0
                  //     : 420.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DealsFilterScreenWidget(
                          responsible: _dealsFilterViewModel.responsible,
                          object: _dealsFilterViewModel.object,
                          company: _dealsFilterViewModel.company,
                          options: _dealsFilterViewModel.options,
                          tags: _dealsFilterViewModel.tags,
                          onResponsibleTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 1,
                                ),
                                Future.delayed(
                                    Duration.zero,
                                    () => _pageController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn))
                              },
                          onObjectTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 2,
                                ),
                                Future.delayed(
                                    Duration.zero,
                                    () => _pageController.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn))
                              },
                          onCompanyTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 3,
                                ),
                                Future.delayed(
                                    Duration.zero,
                                    () => _pageController.animateToPage(
                                          1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        ))
                              },
                          onTagTap: (index) =>
                              _dealsFilterViewModel.sortByStage(index),
                          onApplyTap: () => {
                                _dealsFilterViewModel.apply((params) => {
                                      widget.onPop(DealsFilter(
                                          _dealsFilterViewModel.responsible,
                                          _dealsFilterViewModel.object,
                                          _dealsFilterViewModel.company,
                                          _dealsFilterViewModel.tags,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _dealsFilterViewModel.reset(() =>
                              {widget.onPop(null), Navigator.pop(context)})),
                      _index == 1
                          ? SearchUserScreenWidget(
                              title: Titles.responsible,
                              isRoot: false,
                              onFocus: () => setState,
                              onPop: (user) => {
                                    _dealsFilterViewModel
                                        .setUser(user)
                                        .then((value) => {
                                              _pageController.animateToPage(
                                                0,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeIn,
                                              ),
                                              // setState(
                                              //     () => _isSearching = false),
                                            })
                                  })
                          : _index == 2
                              ? SearchObjectScreenWidget(
                                  title: Titles.object,
                                  isRoot: false,
                                  onFocus: () => setState,
                                  onPop: (object) => {
                                        _dealsFilterViewModel
                                            .setObject(object)
                                            .then((value) => {
                                                  _pageController.animateToPage(
                                                    0,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeIn,
                                                  ),
                                                  // setState(() =>
                                                  //     _isSearching = false),
                                                })
                                      })
                              : SearchCompanyScreenWidget(
                                  title: Titles.company,
                                  isRoot: false,
                                  onFocus: () => setState,
                                  onPop: (company) => {
                                        _dealsFilterViewModel
                                            .setCompany(company)
                                            .then((value) => {
                                                  _pageController.animateToPage(
                                                    0,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeIn,
                                                  ),
                                                  // setState(() =>
                                                  //     _isSearching = false),
                                                })
                                      }),
                    ],
                  ))
            ]));
  }
}
