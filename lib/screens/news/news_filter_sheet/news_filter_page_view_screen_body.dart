import 'package:flutter/material.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/news_filter_view_model.dart';
import 'package:izowork/screens/news/news_filter_sheet/news_filter_screen.dart';
import 'package:izowork/screens/search_user/search_user_screen.dart';
import 'package:izowork/views/dismiss_indicator_widget.dart';
import 'package:provider/provider.dart';

class NewsFilter {
  final User? resposible;
  final List<int> tags;
  final List<int> tags2;
  final List<String> params;

  NewsFilter(this.resposible, this.tags, this.tags2, this.params);
}

class NewsFilterPageViewScreenBodyWidget extends StatefulWidget {
  final Function(NewsFilter?) onPop;

  const NewsFilterPageViewScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _NewsFilterPageViewScreenBodyState createState() =>
      _NewsFilterPageViewScreenBodyState();
}

class _NewsFilterPageViewScreenBodyState
    extends State<NewsFilterPageViewScreenBodyWidget> {
  final PageController _pageController = PageController();
  late NewsFilterViewModel _newsFilterViewModel;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    _newsFilterViewModel =
        Provider.of<NewsFilterViewModel>(context, listen: true);

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
                      ? MediaQuery.of(context).size.height * 0.9
                      : MediaQuery.of(context).padding.bottom == 0.0
                          ? 352.0
                          : 364.0,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      NewsFilterScreenWidget(
                          responsible: _newsFilterViewModel.responsible,
                          options: _newsFilterViewModel.options,
                          tags: _newsFilterViewModel.tags,
                          options2: _newsFilterViewModel.options2,
                          tags2: _newsFilterViewModel.tags2,
                          onTypeTap: () => {
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn),
                                setState(() => _isSearching = true)
                              },
                          onTagTap: (index) =>
                              _newsFilterViewModel.sortByStatus(index),
                          onTag2Tap: (index) =>
                              _newsFilterViewModel.sortByCreatedAt(index),
                          onApplyTap: () => {
                                _newsFilterViewModel.apply((params) => {
                                      widget.onPop(NewsFilter(
                                          _newsFilterViewModel.responsible,
                                          _newsFilterViewModel.tags,
                                          _newsFilterViewModel.tags2,
                                          params)),
                                      Navigator.pop(context)
                                    })
                              },
                          onResetTap: () => _newsFilterViewModel.reset(() =>
                              {widget.onPop(null), Navigator.pop(context)})),
                      SearchUserScreenWidget(
                          title: Titles.responsible,
                          isRoot: false,
                          onFocus: () => setState,
                          onPop: (user) => {
                                _newsFilterViewModel
                                    .setUser(user)
                                    .then((value) => {
                                          _pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn),
                                          setState(() => _isSearching = false),
                                        })
                              })
                    ],
                  ))
            ]));
  }
}