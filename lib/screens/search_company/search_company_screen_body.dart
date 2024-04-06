import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/search_company_view_model.dart';
import 'package:izowork/screens/search_user/views/search_user_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class SearchCompanyScreenBodyWidget extends StatefulWidget {
  final String title;
  final bool isRoot;
  final VoidCallback onFocus;
  final Function(Company?) onPop;

  const SearchCompanyScreenBodyWidget(
      {Key? key,
      required this.title,
      required this.isRoot,
      required this.onFocus,
      required this.onPop})
      : super(key: key);

  @override
  _SearchCompanyScreenBodyState createState() =>
      _SearchCompanyScreenBodyState();
}

class _SearchCompanyScreenBodyState
    extends State<SearchCompanyScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;
  late SearchCompanyViewModel _searchCompanyViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _searchCompanyViewModel.getCompanyList(
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
    _searchCompanyViewModel = Provider.of<SearchCompanyViewModel>(
      context,
      listen: true,
    );

    final _height = MediaQuery.of(context).size.height * 0.9;
    final _addCompanyButton = BorderButtonWidget(
        margin: const EdgeInsets.symmetric(horizontal: 44.0),
        title: Titles.addCompany,
        onTap: () => _searchCompanyViewModel.showCreateCompanyScreen(
            context, (company) => widget.onPop(company)));

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: EdgeInsets.only(top: widget.isRoot ? 20.0 : 0.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(children: [
                          widget.isRoot
                              ? BackButtonWidget(
                                  asset: 'assets/ic_close.svg',
                                  onTap: () => widget.onPop(null),
                                )
                              : BackButtonWidget(
                                  title: Titles.back,
                                  onTap: () => widget.onPop(null),
                                ),
                          Center(child: TitleWidget(text: widget.title))
                        ])),
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
                              EasyDebounce.debounce('company_debouncer',
                                  const Duration(milliseconds: 500), () async {
                                _pagination = Pagination(offset: 0, size: 50);

                                _searchCompanyViewModel
                                    .getCompanyList(
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
                              _searchCompanyViewModel.getCompanyList(
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
                                          ? MediaQuery.of(context)
                                              .viewInsets
                                              .bottom
                                          : MediaQuery.of(context)
                                                      .padding
                                                      .bottom ==
                                                  0.0
                                              ? 12.0
                                              : MediaQuery.of(context)
                                                  .padding
                                                  .bottom) +
                                      124.0,
                                ),
                                itemCount:
                                    _searchCompanyViewModel.companies.length,
                                itemBuilder: (context, index) {
                                  return ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children: [
                                      SearchUserListItemWidget(
                                          key: ValueKey(_searchCompanyViewModel
                                              .companies[index].id),
                                          name: _searchCompanyViewModel
                                              .companies[index].name,
                                          onTap: () => {
                                                FocusScope.of(context)
                                                    .unfocus(),
                                                widget.onPop(
                                                    _searchCompanyViewModel
                                                        .companies[index])
                                              }),
                                      SizedBox(
                                        height: index ==
                                                _searchCompanyViewModel
                                                        .companies.length -
                                                    1
                                            ? 20.0
                                            : 0.0,
                                      ),
                                      index ==
                                              _searchCompanyViewModel
                                                      .companies.length -
                                                  1
                                          ? _addCompanyButton
                                          : Container()
                                    ],
                                  );
                                })))
                  ]),

              /// EMPTY LIST TEXT
              _searchCompanyViewModel.loadingStatus ==
                          LoadingStatus.completed &&
                      _searchCompanyViewModel.companies.isEmpty &&
                      !_isSearching
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Titles.noResult,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                color: HexColors.grey50)),
                        const SizedBox(height: 20.0),
                        _addCompanyButton
                      ],
                    )
                  : Container(),

              /// INDICATOR
              _searchCompanyViewModel.loadingStatus == LoadingStatus.searching
                  ? const LoadingIndicatorWidget()
                  : Container()
            ])));
  }
}
