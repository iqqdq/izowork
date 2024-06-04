import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/companies/companies_filter_sheet/companies_filter_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class CompaniesFilter {
  final User? user;
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  CompaniesFilter(this.user, this.tags, this.tags2, this.params);
}

class CompaniesFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(CompaniesFilter?) onPop;

  const CompaniesFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _CompaniesFilterPageViewScreenBodyState createState() =>
      _CompaniesFilterPageViewScreenBodyState();
}

class _CompaniesFilterPageViewScreenBodyState
    extends State<CompaniesFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late CompaniesFilterViewModel _companiesFilterViewModel;
  // bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    _companiesFilterViewModel = Provider.of<CompaniesFilterViewModel>(
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
                  //     ? MediaQuery.of(context).size.height * 0.9
                  //     : MediaQuery.of(context).padding.bottom == 0.0
                  //         ? 328.0
                  //         : 364.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CompaniesFilterScreenWidget(
                          user: _companiesFilterViewModel.user,
                          options: _companiesFilterViewModel.options,
                          tags: _companiesFilterViewModel.tags,
                          options2: _companiesFilterViewModel.options2,
                          tags2: _companiesFilterViewModel.tags2,
                          onManagerTap: () => {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                ),
                                // setState(() => _isSearching = true)
                              },
                          onTagTap: (index) =>
                              _companiesFilterViewModel.sortByAlphabet(index),
                          onTag2Tap: (index) =>
                              _companiesFilterViewModel.sortByType(index),
                          onApplyTap: () => {
                                _companiesFilterViewModel.apply((params) => {
                                      widget.onPop(CompaniesFilter(
                                          _companiesFilterViewModel.user,
                                          _companiesFilterViewModel.tags,
                                          _companiesFilterViewModel.tags2,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _companiesFilterViewModel.reset(
                              () => {
                                    widget.onPop(null),
                                    Navigator.pop(context)
                                  })),
                      SearchUserScreenWidget(
                          title: Titles.manager,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (user) => {
                                _companiesFilterViewModel
                                    .setUser(user)
                                    .then((value) => {
                                          _pageController.animateToPage(
                                            0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn,
                                          ),
                                          // setState(() => _isSearching = false),
                                        })
                              })
                    ],
                  ))
            ]));
  }
}
