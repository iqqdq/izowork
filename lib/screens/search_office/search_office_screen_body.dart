import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/screens/search_user/views/search_user_list_item_widget.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class SearchOfficeScreenBodyWidget extends StatefulWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Office?) onPop;

  const SearchOfficeScreenBodyWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  _SearchOfficeScreenBodyState createState() => _SearchOfficeScreenBodyState();
}

class _SearchOfficeScreenBodyState extends State<SearchOfficeScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;
  late SearchOfficeViewModel _searchOfficeViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _searchOfficeViewModel.getOfficeList(
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
    final _height = MediaQuery.of(context).size.height * 0.9;

    _searchOfficeViewModel = Provider.of<SearchOfficeViewModel>(
      context,
      listen: true,
    );

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
                              EasyDebounce.debounce('office_debouncer',
                                  const Duration(milliseconds: 500), () async {
                                _pagination = Pagination(offset: 0, size: 50);

                                _searchOfficeViewModel
                                    .getOfficeList(
                                      pagination: _pagination,
                                      search: _textEditingController.text,
                                    )
                                    .then((value) => setState(
                                          () => _isSearching = false,
                                        ));
                              })
                            },
                        onClearTap: () => {
                              _pagination.offset = 0,
                              _searchOfficeViewModel.getOfficeList(
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
                            bottom: (MediaQuery.of(context).viewInsets.bottom !=
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
                          itemCount: _searchOfficeViewModel.offices.length,
                          itemBuilder: (context, index) {
                            return SearchUserListItemWidget(
                              key: ValueKey(
                                  _searchOfficeViewModel.offices[index].id),
                              name: _searchOfficeViewModel.offices[index].name,
                              onTap: () => {
                                FocusScope.of(context).unfocus(),
                                widget.onPop(
                                    _searchOfficeViewModel.offices[index]),
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ]),

              /// EMPTY LIST TEXT
              _searchOfficeViewModel.loadingStatus == LoadingStatus.completed &&
                      _searchOfficeViewModel.offices.isEmpty &&
                      !_isSearching
                  ? Center(
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50)))
                  : Container(),

              /// INDICATOR
              _searchOfficeViewModel.loadingStatus == LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ])));
  }
}
