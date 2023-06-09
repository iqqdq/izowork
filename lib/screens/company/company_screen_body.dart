import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/debouncer.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/pagination.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/company_view_model.dart';
import 'package:izowork/screens/contacts/views/contact_list_item_widget.dart';
import 'package:izowork/screens/products/views/product_list_item_widget.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/segmented_control_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class CompanyScreenBodyWidget extends StatefulWidget {
  final Function(Company?)? onPop;

  const CompanyScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _CompanyScreenBodyState createState() => _CompanyScreenBodyState();
}

class _CompanyScreenBodyState extends State<CompanyScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final PageController _pageController = PageController(initialPage: 0);

  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  late CompanyViewModel _companyViewModel;

  Pagination _pagination = Pagination(offset: 0, size: 50);
  bool _isSearching = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _pagination.offset += 1;
        _companyViewModel.getProductList(
            pagination: _pagination, search: _textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  Future _onRefresh() async {
    _pagination = Pagination(offset: 0, size: 50);
    _companyViewModel.getProductList(
        pagination: _pagination, search: _textEditingController.text);
  }

  Widget _page() {
    return ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 90.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          /// IMAGE
          Center(
              child: Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: _companyViewModel.company?.image == null
                    ? SvgPicture.asset('assets/ic_avatar.svg',
                        color: HexColors.grey40,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: CachedNetworkImage(
                            cacheKey: _companyViewModel.company!.image!,
                            imageUrl: companyMedialUrl +
                                _companyViewModel.company!.image!,
                            width: 80.0,
                            height: 80.0,
                            memCacheWidth: 80 *
                                (MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            fit: BoxFit.cover)))
          ])),
          const SizedBox(height: 16.0),

          /// TAG
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            StatusWidget(
                title: _companyViewModel.company?.type ?? '-',
                status: _companyViewModel.company?.type == 'Поставщик'
                    ? 0
                    : _companyViewModel.company?.type == 'Проектировщик'
                        ? 1
                        : 2)
          ]),
          const SizedBox(height: 16.0),

          /// DESCRIPTION
          const TitleWidget(
              text: Titles.description,
              padding: EdgeInsets.zero,
              isSmall: true),
          const SizedBox(height: 4.0),
          Text(
              _companyViewModel.company?.description == null
                  ? '-'
                  : _companyViewModel.company!.description!.isEmpty
                      ? '-'
                      : _companyViewModel.company!.description!,
              style: TextStyle(
                  height: 1.4,
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// ADDRESS
          const TitleWidget(
              text: Titles.address, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company?.address ?? '-',
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// PHONE
          const TitleWidget(
              text: Titles.phone, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company?.phone ?? '-',
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// EMAIL
          const TitleWidget(
              text: Titles.email, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(
              _companyViewModel.company?.email == null
                  ? '-'
                  : _companyViewModel.company!.email!.isEmpty
                      ? '-'
                      : _companyViewModel.company!.email!,
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// REQUISITES
          const TitleWidget(
              text: Titles.requisites, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(
              _companyViewModel.company?.details == null
                  ? '-'
                  : _companyViewModel.company!.details!.isEmpty
                      ? '-'
                      : _companyViewModel.company!.details!,
              style: TextStyle(
                  height: 1.4,
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// PRODUCT TYPE
          const TitleWidget(
              text: Titles.productsType,
              padding: EdgeInsets.zero,
              isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company?.productType?.name ?? '-',
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// SUCCESS DEAL COUNT
          const TitleWidget(
              text: Titles.successDealCount,
              padding: EdgeInsets.zero,
              isSmall: true),
          const SizedBox(height: 4.0),
          Text(
              _companyViewModel.company?.successfulDeals.toString() ??
                  _companyViewModel.selectedCompany.successfulDeals.toString(),
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// CONTACTS LIST
          _companyViewModel.company == null
              ? Container()
              : _companyViewModel.company!.contacts.isEmpty
                  ? Container()
                  : const TitleWidget(
                      text: Titles.contacts,
                      padding: EdgeInsets.zero,
                      isSmall: true),
          ListView.builder(
              padding: const EdgeInsets.only(top: 10.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _companyViewModel.company?.contacts.length,
              itemBuilder: (context, index) {
                return _companyViewModel.company == null
                    ? Container()
                    : ContactListItemWidget(
                        contact: _companyViewModel.company?.contacts[index] ??
                            _companyViewModel.selectedCompany.contacts[index],
                        onContactTap: () =>
                            _companyViewModel.showContactScreen(context, index),
                        onPhoneTap: () => {},
                        onLinkTap: (url) => _companyViewModel.openUrl(url));
              })
        ]);
  }

  Widget _products() {
    return Column(children: [
      SizedBox(
          height: 56.0,
          child: Center(
              child:

                  /// SEARCH INPUT
                  InputWidget(
                      textEditingController: _textEditingController,
                      focusNode: _focusNode,
                      isSearchInput: true,
                      placeholder: '${Titles.search}...',
                      onTap: () => setState,
                      onChange: (text) => {
                            setState(() => _isSearching = true),
                            _debouncer.run(() {
                              _pagination = Pagination(offset: 0, size: 50);

                              _companyViewModel
                                  .getProductList(
                                      pagination: _pagination,
                                      search: _textEditingController.text)
                                  .then((value) =>
                                      setState(() => _isSearching = false));
                            })
                          },
                      onClearTap: () => {
                            _companyViewModel.resetFilter(),
                            _pagination.offset = 0,
                            _companyViewModel.getProductList(
                                pagination: _pagination,
                                search: _textEditingController.text)
                          }))),
      const SizedBox(height: 8.0),
      const SeparatorWidget(),

      /// PRODUCTS LIST VIEW
      Expanded(
          child: LiquidPullToRefresh(
              color: HexColors.primaryMain,
              backgroundColor: HexColors.white,
              springAnimationDurationInMilliseconds: 300,
              onRefresh: _onRefresh,
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: MediaQuery.of(context).padding.bottom + 70.0),
                  itemCount: _companyViewModel.products.length,
                  itemBuilder: (context, index) {
                    return ProductsListItemWidget(
                        tag: index.toString(),
                        product: _companyViewModel.products[index],
                        onTap: () => _companyViewModel.showProductPageScreen(
                            context, index));
                  })))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _companyViewModel = Provider.of<CompanyViewModel>(context, listen: true);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            toolbarHeight: _index == 0 ? 129.0 : 116.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: HexColors.white90,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                const SizedBox(width: 16.0),
                BackButtonWidget(
                    onTap: () => {
                          if (widget.onPop != null)
                            widget.onPop!(_companyViewModel.company),
                          Navigator.pop(context)
                        }),
                Expanded(
                    child: Text(_companyViewModel.company?.name ?? '-',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: HexColors.black,
                            fontSize: 18.0,
                            fontFamily: 'PT Root UI',
                            fontWeight: FontWeight.bold))),
                const SizedBox(width: 36.0)
              ]),

              const SizedBox(height: 16.0),

              /// SEGMENTED CONTROL
              SegmentedControlWidget(
                  titles: const [Titles.info, Titles.products],
                  backgroundColor: HexColors.grey10,
                  activeColor: HexColors.black,
                  disableColor: HexColors.grey40,
                  thumbColor: HexColors.white,
                  borderColor: HexColors.grey20,
                  onTap: (index) => {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linearToEaseOut),
                        setState(() => _index == index)
                      }),
              SizedBox(height: _index == 0.0 ? 16.0 : 4.0),
              _index == 0 ? const SeparatorWidget() : Container()
            ])),
        body: Stack(children: [
          Container(
              color: HexColors.white90,
              child: PageView(
                  controller: _pageController,
                  children: [_page(), _products()],
                  onPageChanged: (page) => {
                        setState(() => _index = page),
                        FocusScope.of(context).unfocus()
                      })),

          /// EMPTY LIST TEXT
          _index == 1 &&
                  _companyViewModel.loadingStatus == LoadingStatus.completed &&
                  _companyViewModel.products.isEmpty &&
                  !_isSearching
              ? Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 100.0),
                      child: Text(Titles.noResult,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              color: HexColors.grey50))))
              : Container(),

          _index == 0
              ?

              /// EDIT BUTTON
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      child: ButtonWidget(
                          title: Titles.edit,
                          onTap: () => _companyViewModel
                              .showCompanyEditScreen(context))))
              :

              /// FILTER BUTTON
              SafeArea(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: FilterButtonWidget(
                            onTap: () =>
                                _companyViewModel.showProductFilterSheet(
                                    context,
                                    () => {
                                          _pagination =
                                              Pagination(offset: 0, size: 50),
                                          _companyViewModel.getProductList(
                                              pagination: _pagination,
                                              search:
                                                  _textEditingController.text)
                                        }),
                            // onClearTap: () => {}
                          )))),
        ]));
  }
}
