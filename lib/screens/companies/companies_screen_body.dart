import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/models/companies_view_model.dart';
import 'package:izowork/screens/companies/views/companies_list_item_widget.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/floating_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:provider/provider.dart';

class CompaniesScreenBodyWidget extends StatefulWidget {
  const CompaniesScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _CompaniesScreenBodyState createState() => _CompaniesScreenBodyState();
}

class _CompaniesScreenBodyState extends State<CompaniesScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  late CompaniesViewModel _companiesViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _companiesViewModel.getCompanyList(
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

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _companiesViewModel.getCompanyList(
        pagination: _pagination, search: _textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    _companiesViewModel =
        Provider.of<CompaniesViewModel>(context, listen: true);

    return Scaffold(
        backgroundColor: HexColors.white,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingButtonWidget(
            onTap: () => _companiesViewModel.showCreateCompanyScreen(context)),
        appBar: AppBar(
            toolbarHeight: 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Column(children: [
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(Titles.companies,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
                ])
              ]),
              const SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child:

                        /// SEARCH INPUT
                        InputWidget(
                            textEditingController: _textEditingController,
                            focusNode: _focusNode,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            isSearchInput: true,
                            placeholder: '${Titles.search}...',
                            onTap: () => setState,
                            onChange: (text) => {
                                  setState(() => _isSearching = true),
                                  _debouncer.run(() {
                                    _pagination =
                                        Pagination(offset: 0, size: 50);

                                    _companiesViewModel
                                        .getCompanyList(
                                            pagination: _pagination,
                                            search: _textEditingController.text)
                                        .then((value) => setState(
                                            () => _isSearching = false));
                                  })
                                },
                            onClearTap: () => {
                                  _companiesViewModel.resetFilter(),
                                  _pagination.offset = 0,
                                  _companiesViewModel.getCompanyList(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                }))
              ])
            ])),
        body: SizedBox.expand(
            child: Stack(children: [
          /// COMPANIES LIST VIEW
          RefreshIndicator(
              onRefresh: _onRefresh,
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: 60.0 + MediaQuery.of(context).padding.bottom),
                  itemCount: _companiesViewModel.companies.length,
                  itemBuilder: (context, index) {
                    return CompaniesListItemWidget(
                        company: _companiesViewModel.companies[index],
                        onTap: () => _companiesViewModel
                            .showCompanyPageViewScreen(context, index));
                  })),
          const SeparatorWidget(),

          /// EMPTY LIST TEXT
          _companiesViewModel.loadingStatus == LoadingStatus.completed &&
                  _companiesViewModel.companies.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 116.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          /// FILTER BUTTON
          SafeArea(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: FilterButtonWidget(
                        onTap: () =>
                            _companiesViewModel.showCompaniesFilterSheet(
                                context,
                                () => {
                                      _pagination =
                                          Pagination(offset: 0, size: 50),
                                      _companiesViewModel.getCompanyList(
                                          pagination: _pagination,
                                          search: _textEditingController.text)
                                    }),
                        // onClearTap: () => {}
                      )))),

          /// INDICATOR
          _companiesViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 90.0),
                  child: LoadingIndicatorWidget())
              : Container()
        ])));
  }
}
