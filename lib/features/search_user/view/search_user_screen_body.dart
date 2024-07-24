import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/search_user/view_model/search_user_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/search_user/view/views/search_user_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class SearchUserScreenBodyWidget extends StatefulWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(User?) onPop;

  const SearchUserScreenBodyWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  _SearchUserScreenBodyState createState() => _SearchUserScreenBodyState();
}

class _SearchUserScreenBodyState extends State<SearchUserScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination();
  bool _isSearching = false;
  late SearchUserViewModel _searchUserViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
        _searchUserViewModel.getUserList(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _searchUserViewModel = Provider.of<SearchUserViewModel>(
      context,
      listen: true,
    );

    final _height = MediaQuery.of(context).size.height * 0.9;

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: EdgeInsets.only(top: widget.isRoot ? 20.0 : 8.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    /// TITLE / CLOSE BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: widget.isRoot
                          ? Row(children: [
                              const SizedBox(width: 24.0),
                              Expanded(
                                child: Center(
                                    child: TitleWidget(text: widget.title)),
                              ),
                              BackButtonWidget(
                                asset: 'assets/ic_close.svg',
                                onTap: () => widget.onPop(null),
                              )
                            ])
                          : Stack(children: [
                              BackButtonWidget(
                                title: Titles.back,
                                onTap: () => widget.onPop(null),
                              ),
                              Center(child: TitleWidget(text: widget.title))
                            ]),
                    ),
                    const SizedBox(height: 16.0),

                    /// SEARCH INPUT
                    InputWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        isSearchInput: true,
                        placeholder: '${Titles.search}...',
                        onTap: () => setState,
                        onChange: (text) => {
                              setState(() => _isSearching = true),
                              EasyDebounce.debounce('user_debouncer',
                                  const Duration(milliseconds: 500), () async {
                                _pagination = Pagination();

                                _searchUserViewModel
                                    .getUserList(
                                        pagination: _pagination,
                                        search: _textEditingController.text)
                                    .then((value) =>
                                        setState(() => _isSearching = false));
                              })
                            },
                        onClearTap: () => {
                              _pagination.offset = 0,
                              _searchUserViewModel.getUserList(
                                  pagination: _pagination)
                            }),
                    const SizedBox(height: 16.0),

                    /// SEPARATOR
                    const SeparatorWidget(),

                    /// USER LIST VIEW
                    SizedBox(
                      height: _height - 86.0,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.only(
                              top: 12.0,
                              left: 16.0,
                              right: 16.0,
                              bottom: (MediaQuery.of(context)
                                              .viewInsets
                                              .bottom !=
                                          0.0
                                      ? MediaQuery.of(context).viewInsets.bottom
                                      : MediaQuery.of(context).padding.bottom ==
                                              0.0
                                          ? 12.0
                                          : MediaQuery.of(context)
                                              .padding
                                              .bottom) +
                                  124.0,
                            ),
                            itemCount: _searchUserViewModel.users.length,
                            itemBuilder: (context, index) {
                              final user = _searchUserViewModel.users[index];

                              return SearchUserListItemWidget(
                                key: ValueKey(user.id),
                                name: user.name,
                                onTap: () => {
                                  FocusScope.of(context).unfocus(),
                                  widget.onPop(user),
                                },
                              );
                            }),
                      ),
                    )
                  ]),

              /// EMPTY LIST TEXT
              _searchUserViewModel.loadingStatus == LoadingStatus.completed &&
                      _searchUserViewModel.users.isEmpty &&
                      !_isSearching
                  ? const NoResultTitle()
                  : Container(),

              /// INDICATOR
              _searchUserViewModel.loadingStatus == LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ])));
  }
}
