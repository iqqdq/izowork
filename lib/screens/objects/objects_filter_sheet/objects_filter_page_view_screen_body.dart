import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';

import 'package:izowork/entities/responses/responses.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/screens/objects/objects_filter_sheet/objects_filter_screen.dart';
import 'package:izowork/screens/search_company/search_company_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class ObjectsFilter {
  final User? manager;
  final Company? designer;
  final Company? contractor;
  final Company? customer;
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  ObjectsFilter(this.manager, this.designer, this.contractor, this.customer,
      this.tags, this.tags2, this.params);
}

class ObjectsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(ObjectsFilter?) onPop;

  const ObjectsFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _ObjectsFilterPageViewScreenBodyState createState() =>
      _ObjectsFilterPageViewScreenBodyState();
}

class _ObjectsFilterPageViewScreenBodyState
    extends State<ObjectsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late ObjectsFilterViewModel _objectsFilterViewModel;
  // bool _isSearching = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    _objectsFilterViewModel = Provider.of<ObjectsFilterViewModel>(
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
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ObjectsFilterScreenWidget(
                          manager: _objectsFilterViewModel.manager,
                          designer: _objectsFilterViewModel.designer,
                          contractor: _objectsFilterViewModel.contractor,
                          customer: _objectsFilterViewModel.customer,
                          options: _objectsFilterViewModel.options,
                          tags: _objectsFilterViewModel.tags,
                          options2: _objectsFilterViewModel.options2,
                          tags2: _objectsFilterViewModel.tags2,
                          onManagerTap: () => {
                                // setState(() => _isSearching = true),
                                _pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onDesignerTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 0,
                                ),
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onContractorTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 1,
                                ),
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn)
                              },
                          onCustomerTap: () => {
                                setState(
                                  () =>
                                      // _isSearching = true,
                                      _index = 2,
                                ),
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                              },
                          onTagTap: (index) =>
                              _objectsFilterViewModel.sortByStage(index),
                          onTag2Tap: (index) => _objectsFilterViewModel
                              .sortByEffectiveness(index),
                          onApplyTap: () => {
                                _objectsFilterViewModel.apply((params) => {
                                      widget.onPop(ObjectsFilter(
                                          _objectsFilterViewModel.manager,
                                          _objectsFilterViewModel.designer,
                                          _objectsFilterViewModel.contractor,
                                          _objectsFilterViewModel.customer,
                                          _objectsFilterViewModel.tags,
                                          _objectsFilterViewModel.tags2,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () =>
                              _objectsFilterViewModel.reset(() => {
                                    widget.onPop(null),
                                    Navigator.pop(context),
                                  })),
                      SearchCompanyScreenWidget(
                          title: _index == 0
                              ? Titles.designer
                              : _index == 1
                                  ? Titles.contractor
                                  : Titles.customer,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (company) => {
                                _objectsFilterViewModel
                                    .setCompany(company, _index)
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
                      SearchUserScreenWidget(
                          title: Titles.manager,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (company) => {
                                _objectsFilterViewModel
                                    .setManager(company)
                                    .then((value) => {
                                          _pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn),
                                          // setState(() => _isSearching = false),
                                        })
                              })
                    ],
                  ))
            ]));
  }
}
