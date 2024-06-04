import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/repositories/local_storage/local_storage_repository_interface.dart';
import 'package:izowork/screens/company_create/company_create_screen.dart';
import 'package:izowork/screens/contact/contact_screen.dart';
import 'package:izowork/screens/contacts/views/contact_list_item_widget.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/screens/single_company_map/single_company_map_screen.dart';
import 'package:izowork/views/views.dart';

class CompanyScreenBodyWidget extends StatefulWidget {
  final Function(Company?)? onPop;

  const CompanyScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _CompanyScreenBodyState createState() => _CompanyScreenBodyState();
}

class _CompanyScreenBodyState extends State<CompanyScreenBodyWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();

  // Pagination _pagination = Pagination(offset: 0, size: 50);
  int _index = 0;

  late CompanyViewModel _companyViewModel;

  @override
  void initState() {
    super.initState();

    // TODO: - REPLACE WITH GET ACTION'S
    //   _scrollController.addListener(() {
    //     if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent) {
    //       _pagination.offset += 1;
    //       _companyViewModel.getProductList(
    //           pagination: _pagination, search: _textEditingController.text);
    //     }
    //   });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - FUNCTIONS

  // TODO: - REPLACE WITH GET ACTION'S
  // Future _onRefresh() async {
  // _pagination = Pagination(offset: 0, size: 50);
  // await _companyViewModel.getProductList(
  //   pagination: _pagination,
  //   search: _textEditingController.text,
  // );
  // }

  Widget _page() {
    return Column(
      children: [
        const SeparatorWidget(),
        Expanded(
          child: ListView(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 90.0
                    : MediaQuery.of(context).padding.bottom + 70.0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                /// IMAGE
                Center(
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: _companyViewModel.company?.image == null
                          ? SvgPicture.asset(
                              'assets/ic_avatar.svg',
                              colorFilter: ColorFilter.mode(
                                HexColors.grey40,
                                BlendMode.srcIn,
                              ),
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.cover,
                            )
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
                                fit: BoxFit.cover,
                              ),
                            ),
                    )
                  ]),
                ),
                const SizedBox(height: 16.0),

                /// TAG
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  StatusWidget(
                    title: _companyViewModel.company?.type ?? '-',
                    status: _companyViewModel.company?.type == 'Поставщик'
                        ? 0
                        : _companyViewModel.company?.type == 'Проектировщик'
                            ? 1
                            : 2,
                  )
                ]),
                const SizedBox(height: 16.0),

                /// MANAGER
                GestureDetector(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.manager,
                          isSmall: true,
                        ),
                        Text(_companyViewModel.company?.manager?.name ?? '-',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PT Root UI',
                              decoration: TextDecoration.underline,
                            )),
                      ]),
                  onTap: () => _showUserScreen(),
                ),
                const SizedBox(height: 16.0),

                /// DESCRIPTION
                const TitleWidget(
                  text: Titles.description,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
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
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// ADDRESS
                const TitleWidget(
                  text: Titles.address,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
                const SizedBox(height: 4.0),
                Text(_companyViewModel.company?.address ?? '-',
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    )),
                const SizedBox(height: 16.0),

                /// ADDRESS
                _companyViewModel.company?.lat == null
                    ? Container()
                    : const TitleWidget(
                        text: Titles.coordinates,
                        padding: EdgeInsets.zero,
                        isSmall: true,
                      ),
                SizedBox(
                    height: _companyViewModel.company?.lat == null ? 0.0 : 4.0),

                /// COORDINATES
                _companyViewModel.company?.lat == null
                    ? Container()
                    : Row(children: [
                        Expanded(
                          child: Text(
                              '${_companyViewModel.company?.lat}, ${_companyViewModel.company?.long}',
                              style: TextStyle(
                                color: HexColors.black,
                                fontSize: 14.0,
                                fontFamily: 'PT Root UI',
                              )),
                        ),
                        GestureDetector(
                          onTap: () => _showSingleCompanyOnMap(),
                          child: SvgPicture.asset(
                            'assets/ic_map.svg',
                            colorFilter: ColorFilter.mode(
                              HexColors.primaryMain,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ]),
                SizedBox(
                    height:
                        _companyViewModel.company?.lat == null ? 0.0 : 16.0),

                /// PHONE
                const TitleWidget(
                  text: Titles.phone,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  _companyViewModel.company?.phone ?? '-',
                  style: TextStyle(
                    color: HexColors.black,
                    fontSize: 14.0,
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// EMAIL
                const TitleWidget(
                  text: Titles.email,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
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
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// REQUISITES
                const TitleWidget(
                  text: Titles.requisites,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
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
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// PRODUCT TYPE
                const TitleWidget(
                  text: Titles.productsType,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  _companyViewModel.company?.productType?.name ?? '-',
                  style: TextStyle(
                    color: HexColors.black,
                    fontSize: 14.0,
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// SUCCESS DEAL COUNT
                const TitleWidget(
                  text: Titles.successDealCount,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  _companyViewModel.company?.successfulDeals.toString() ??
                      _companyViewModel.selectedCompany.successfulDeals
                          .toString(),
                  style: TextStyle(
                    color: HexColors.black,
                    fontSize: 14.0,
                    fontFamily: 'PT Root UI',
                  ),
                ),
                const SizedBox(height: 16.0),

                /// CONTACTS LIST
                const TitleWidget(
                  text: Titles.contacts,
                  padding: EdgeInsets.zero,
                  isSmall: true,
                ),
                _companyViewModel.company == null
                    ? Container()
                    : _companyViewModel.company!.contacts.isEmpty
                        ? Text(
                            '-',
                            style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI',
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                _companyViewModel.company?.contacts.length,
                            itemBuilder: (context, index) {
                              return _companyViewModel.company == null
                                  ? Container()
                                  : ContactListItemWidget(
                                      key: ValueKey(_companyViewModel
                                          .company?.contacts[index]),
                                      contact: _companyViewModel
                                              .company?.contacts[index] ??
                                          _companyViewModel
                                              .selectedCompany.contacts[index],
                                      onContactTap: () =>
                                          _showContactScreen(index),
                                      onPhoneTap: () => {},
                                      onLinkTap: (url) =>
                                          _companyViewModel.openUrl(url),
                                    );
                            }),
              ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _companyViewModel = Provider.of<CompanyViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
          toolbarHeight: 112.0,
          titleSpacing: 0.0,
          backgroundColor: HexColors.white90,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    titles: const [
                      Titles.info,
                      Titles.actions,
                    ],
                    backgroundColor: HexColors.grey10,
                    activeColor: HexColors.black,
                    disableColor: HexColors.grey40,
                    thumbColor: HexColors.white,
                    borderColor: HexColors.grey20,
                    onTap: (index) => {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linearToEaseOut,
                          ),
                          setState(() => _index == index)
                        }),
                const SizedBox(height: 16.0),
              ])),
      body: Stack(children: [
        Container(
          color: HexColors.white90,
          child: PageView(
              controller: _pageController,
              children: [
                _page(),
                Container(), // TODO: REPLACE WITH ACTION'S
                // _products() // TODO: - DELETE
              ],
              onPageChanged: (page) => {
                    setState(() => _index = page),
                    FocusScope.of(context).unfocus()
                  }),
        ),

        /// EMPTY LIST TEXT
        _index == 1 &&
                _companyViewModel.loadingStatus == LoadingStatus.completed
            // _companyViewModel.products.isEmpty && TODO: - DELETE
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    Titles.noResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        color: HexColors.grey50),
                  ),
                ),
              )
            : Container(),

        /// EDIT BUTTON
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom == 0.0
                    ? 20.0
                    : MediaQuery.of(context).padding.bottom),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonWidget(
                  title: Titles.edit, onTap: () => _showCompanyEditScreen()),
            ))
      ]),
    );
  }

  // MARK: -
  // MARK: - PUSH

  Future _showUserScreen() async {
    if (_companyViewModel.company?.manager == null) return;

    User? user = await GetIt.I<LocalStorageRepositoryInterface>().getUser();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
            isMine: _companyViewModel.company?.manager?.id == user?.id,
            user: _companyViewModel.company!.manager!,
            onPop: (user) => _companyViewModel.setManager(user),
          ),
        ));
  }

  // TODO: - DELETE
  // void _showProductPageScreen(int index) => Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => ProductPageScreenWidget(
  //             product: _companyViewModel.products[index])));

  void _showSingleCompanyOnMap() {
    if (_companyViewModel.company == null) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleCompanyMapScreenWidget(
                company: _companyViewModel.company!)));
  }

  void _showCompanyEditScreen() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyCreateScreenWidget(
            company: _companyViewModel.company,
            onPop: (company) => _companyViewModel
                .getCompanyById(_companyViewModel.selectedCompany.id)),
      ));

  void _showContactScreen(int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactScreenWidget(
                contact: _companyViewModel.company!.contacts[index],
                onDelete: (contact) => _companyViewModel.setContact(contact),
              )));
}
