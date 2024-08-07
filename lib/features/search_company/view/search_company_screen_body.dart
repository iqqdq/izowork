import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/search_company/view_model/search_company_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/company_create/view/company_create_screen.dart';
import 'package:izowork/features/search_user/view/views/search_user_list_item_widget.dart';
import 'package:izowork/views/views.dart';
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

  Pagination _pagination = Pagination();
  bool _isSearching = false;

  late SearchCompanyViewModel _searchCompanyViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.increase();
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
        onTap: () => _showCreateCompanyScreen());

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
                /// TITLE / CLOSE BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: widget.isRoot
                      ? Row(children: [
                          const SizedBox(width: 24.0),
                          Expanded(
                            child:
                                Center(child: TitleWidget(text: widget.title)),
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
                          EasyDebounce.debounce('company_debouncer',
                              const Duration(milliseconds: 500), () async {
                            _pagination = Pagination();

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
                          bottom: (MediaQuery.of(context).viewInsets.bottom !=
                                      0.0
                                  ? MediaQuery.of(context).viewInsets.bottom
                                  : MediaQuery.of(context).padding.bottom == 0.0
                                      ? 12.0
                                      : MediaQuery.of(context).padding.bottom) +
                              124.0,
                        ),
                        itemCount: _searchCompanyViewModel.companies.length,
                        itemBuilder: (context, index) {
                          final company =
                              _searchCompanyViewModel.companies[index];

                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: [
                              SearchUserListItemWidget(
                                  key: ValueKey(company.id),
                                  name: company.name,
                                  onTap: () => {
                                        FocusScope.of(context).unfocus(),
                                        widget.onPop(company)
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
                                      _searchCompanyViewModel.companies.length -
                                          1
                                  ? _addCompanyButton
                                  : Container()
                            ],
                          );
                        }),
                  ),
                )
              ]),

          /// EMPTY LIST TEXT
          _searchCompanyViewModel.loadingStatus == LoadingStatus.completed &&
                  _searchCompanyViewModel.companies.isEmpty &&
                  !_isSearching
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const NoResultTitle(),
                    const SizedBox(height: 20.0),
                    _addCompanyButton
                  ],
                )
              : Container(),

          /// INDICATOR
          _searchCompanyViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showCreateCompanyScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyCreateScreenWidget(
            onPop: (company) => {
                  if (company != null) widget.onPop(company),
                }),
      ));
}
