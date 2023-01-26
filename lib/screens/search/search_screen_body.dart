import 'package:flutter/material.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/models/search_view_model.dart';
import 'package:izowork/screens/search/views/search_list_item_widget.dart';
import 'package:izowork/screens/search/views/search_object_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class SearchBodyScreenWidget extends StatefulWidget {
  final bool isRoot;
  final VoidCallback onPop;

  const SearchBodyScreenWidget(
      {Key? key, required this.isRoot, required this.onPop})
      : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBodyScreenWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late SearchViewModel _searchViewModel;
  bool _show = false; // TODO DELETE

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 0.8;

    _searchViewModel = Provider.of<SearchViewModel>(context, listen: true);

    return Material(
        type: MaterialType.transparency,
        child: Container(
            height: _height,
            color: HexColors.white,
            padding: EdgeInsets.only(top: widget.isRoot ? 16.0 : 8.0),
            child: Stack(children: [
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(children: [
                          widget.isRoot
                              ? Container()
                              : BackButtonWidget(
                                  title: Titles.back,
                                  onTap: () => widget.onPop(),
                                ),
                          Center(
                              child: TitleWidget(
                                  text: _searchViewModel.searchType ==
                                          SearchType.responsible
                                      ? Titles.responsible
                                      : _searchViewModel.searchType ==
                                              SearchType.manager
                                          ? Titles.manager
                                          : _searchViewModel.searchType ==
                                                  SearchType.developer
                                              ? Titles.developer
                                              : _searchViewModel.searchType ==
                                                      SearchType.company
                                                  ? Titles.company
                                                  : _searchViewModel
                                                              .searchType ==
                                                          SearchType.type
                                                      ? Titles.type
                                                      : _searchViewModel
                                                                  .searchType ==
                                                              SearchType.filial
                                                          ? Titles.filial
                                                          : _searchViewModel
                                                                      .searchType ==
                                                                  SearchType
                                                                      .employee
                                                              ? Titles.employee
                                                              : _searchViewModel
                                                                          .searchType ==
                                                                      SearchType
                                                                          .product
                                                                  ? Titles
                                                                      .product
                                                                  : _searchViewModel
                                                                              .searchType ==
                                                                          SearchType
                                                                              .phase
                                                                      ? Titles
                                                                          .phase
                                                                      : Titles
                                                                          .object))
                        ])),
                    const SizedBox(height: 16.0),

                    /// SEARCH INPUT
                    InputWidget(
                        textEditingController: _textEditingController,
                        focusNode: _focusNode,
                        isSearchInput: true,
                        placeholder: '${Titles.search}...',
                        onTap: () => setState,
                        onChange: (text) =>
                            // TODO SEARCH MAP OBJECT
                            setState(() => _show = text.isEmpty ? false : true),
                        onClearTap: () =>
                            // TODO CLEAR MAP OBJECT SEARCH
                            setState(() => _show = false)),
                    const SizedBox(height: 16.0),

                    /// SEPARATOR
                    const SeparatorWidget(),

                    /// USER LIST VIEW
                    _show
                        ? SizedBox(
                            height: _height - 86.0,
                            child: ListView.builder(
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
                                        124.0),
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return _searchViewModel.searchType ==
                                          SearchType.object
                                      ? SearchObjectListItemWidget(
                                          address: 'Адресс',
                                          name: 'Название объекта',
                                          onTap: () => {})
                                      : SearchListItemWidget(
                                          name: index.toString(),
                                          onTap: () => widget.onPop());
                                }))
                        : Container()
                  ]),

              /// PLACEHOLDER
              !_show
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Row(children: [
                            Expanded(
                                child: Text(
                                    _searchViewModel.searchType ==
                                            SearchType.responsible
                                        ? Titles.enterResponsibleName
                                        : _searchViewModel.searchType ==
                                                SearchType.manager
                                            ? Titles.enterManagerName
                                            : _searchViewModel.searchType ==
                                                    SearchType.developer
                                                ? Titles.enterDeveloperName
                                                : _searchViewModel.searchType ==
                                                        SearchType.company
                                                    ? Titles.enterCompanyName
                                                    : _searchViewModel
                                                                .searchType ==
                                                            SearchType.type
                                                        ? Titles.enterTypeName
                                                        : _searchViewModel
                                                                    .searchType ==
                                                                SearchType
                                                                    .employee
                                                            ? Titles
                                                                .enterEmployeeName
                                                            : _searchViewModel
                                                                        .searchType ==
                                                                    SearchType
                                                                        .filial
                                                                ? Titles
                                                                    .enterFilialName
                                                                : _searchViewModel
                                                                            .searchType ==
                                                                        SearchType
                                                                            .product
                                                                    ? Titles
                                                                        .enterProductName
                                                                    : _searchViewModel.searchType ==
                                                                            SearchType
                                                                                .phase
                                                                        ? Titles
                                                                            .enterPhaseName
                                                                        : Titles
                                                                            .enterObjectName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: HexColors.grey30,
                                        fontFamily: 'PT Root UI')))
                          ])
                        ])
                  : Container()
            ])));
  }
}
