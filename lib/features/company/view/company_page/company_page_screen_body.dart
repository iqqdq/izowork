import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/repositories/local_storage_repository/local_storage_repository_interface.dart';
import 'package:izowork/features/company_create/view/company_create_screen.dart';
import 'package:izowork/features/contact/view/contact_screen.dart';
import 'package:izowork/features/contacts/view/views/contact_list_item_widget.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/features/single_company_map/view/single_company_map_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:izowork/features/company/view_model/company_page_view_model.dart';
import 'package:izowork/injection_container.dart';

class CompanyPageScreenBodyWidget extends StatefulWidget {
  final String id;
  final Function(Company?) onPop;

  const CompanyPageScreenBodyWidget({
    Key? key,
    required this.id,
    required this.onPop,
  }) : super(key: key);

  @override
  _CompanyPageScreenBodyState createState() => _CompanyPageScreenBodyState();
}

class _CompanyPageScreenBodyState extends State<CompanyPageScreenBodyWidget>
    with AutomaticKeepAliveClientMixin {
  late CompanyPageViewModel _companyPageViewModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    widget.onPop(_companyPageViewModel.company);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _companyPageViewModel = Provider.of<CompanyPageViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      backgroundColor: HexColors.white90,
      body: _companyPageViewModel.company == null
          ? const LoadingIndicatorWidget()
          : Material(
              type: MaterialType.transparency,
              child: Container(
                color: HexColors.white,
                child: Stack(children: [
                  const SeparatorWidget(),
                  ListView(
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
                              child: _companyPageViewModel.company?.image ==
                                      null
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
                                        cacheKey: _companyPageViewModel
                                            .company!.image!,
                                        imageUrl: companyMedialUrl +
                                            _companyPageViewModel
                                                .company!.image!,
                                        width: 80.0,
                                        height: 80.0,
                                        memCacheWidth: 80 *
                                            (MediaQuery.of(context)
                                                    .devicePixelRatio)
                                                .round(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            )
                          ]),
                        ),
                        const SizedBox(height: 16.0),

                        /// TAG
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatusWidget(
                                title:
                                    _companyPageViewModel.company?.type ?? '-',
                                status: _companyPageViewModel.company?.type ==
                                        'Поставщик'
                                    ? 0
                                    : _companyPageViewModel.company?.type ==
                                            'Проектировщик'
                                        ? 1
                                        : 2,
                              )
                            ]),
                        const SizedBox(height: 16.0),

                        ///  NAME
                        const TitleWidget(
                          padding: EdgeInsets.only(bottom: 4.0),
                          text: Titles.companyName,
                          isSmall: true,
                        ),
                        SubtitleWidget(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          text: _companyPageViewModel.company?.name ?? '',
                        ),

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
                                Text(
                                  _companyPageViewModel
                                          .company?.manager?.name ??
                                      '-',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'PT Root UI',
                                  ),
                                ),
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
                          _companyPageViewModel.company?.description == null
                              ? '-'
                              : _companyPageViewModel
                                      .company!.description!.isEmpty
                                  ? '-'
                                  : _companyPageViewModel.company!.description!,
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
                        Text(_companyPageViewModel.company?.address ?? '-',
                            style: TextStyle(
                              color: HexColors.black,
                              fontSize: 14.0,
                              fontFamily: 'PT Root UI',
                            )),
                        const SizedBox(height: 16.0),

                        /// ADDRESS
                        _companyPageViewModel.company?.lat == null
                            ? Container()
                            : const TitleWidget(
                                text: Titles.coordinates,
                                padding: EdgeInsets.zero,
                                isSmall: true,
                              ),
                        SizedBox(
                            height: _companyPageViewModel.company?.lat == null
                                ? 0.0
                                : 4.0),

                        /// COORDINATES
                        _companyPageViewModel.company?.lat == null
                            ? Container()
                            : Row(children: [
                                Expanded(
                                  child: Text(
                                      '${_companyPageViewModel.company?.lat}, ${_companyPageViewModel.company?.long}',
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
                            height: _companyPageViewModel.company?.lat == null
                                ? 0.0
                                : 16.0),

                        /// BIM
                        const TitleWidget(
                          text: Titles.companyBIM,
                          padding: EdgeInsets.zero,
                          isSmall: true,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          _companyPageViewModel.company == null
                              ? '-'
                              : _companyPageViewModel.company!.bim == null
                                  ? '-'
                                  : _companyPageViewModel
                                          .company!.bim!.isNotEmpty
                                      ? _companyPageViewModel.company!.bim!
                                      : '-',
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
                          _companyPageViewModel.company?.email == null
                              ? '-'
                              : _companyPageViewModel.company!.email!.isEmpty
                                  ? '-'
                                  : _companyPageViewModel.company!.email!,
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
                          _companyPageViewModel.company?.details == null
                              ? '-'
                              : _companyPageViewModel.company!.details!.isEmpty
                                  ? '-'
                                  : _companyPageViewModel.company!.details!,
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
                          _companyPageViewModel.company?.productType?.name ??
                              '-',
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
                          _companyPageViewModel.company?.successfulDeals
                                  .toString() ??
                              '0',
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
                        _companyPageViewModel.company == null
                            ? Container()
                            : _companyPageViewModel.company!.contacts.isEmpty
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _companyPageViewModel
                                        .company?.contacts.length,
                                    itemBuilder: (context, index) {
                                      final contact = _companyPageViewModel
                                          .company?.contacts[index];

                                      return contact == null
                                          ? Container()
                                          : ContactListItemWidget(
                                              key: ValueKey(contact.id),
                                              contact: contact,
                                              onContactTap: () =>
                                                  _showContactScreen(index),
                                              onPhoneTap: () => {},
                                              onLinkTap: (url) =>
                                                  _companyPageViewModel
                                                      .openUrl(url),
                                            );
                                    }),
                      ]),

                  /// EDIT BUTTON
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0.0
                            ? 20.0
                            : MediaQuery.of(context).padding.bottom),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonWidget(
                        title: Titles.edit,
                        onTap: () => _showCompanyEditScreen(),
                      ),
                    ),
                  ),

                  /// INDICATOR
                  _companyPageViewModel.loadingStatus == LoadingStatus.searching
                      ? const LoadingIndicatorWidget()
                      : Container(),
                ]),
              ),
            ),
    );
  }

  // MARK: -
  // MARK: - PUSH

  Future _showUserScreen() async {
    if (_companyPageViewModel.company?.manager == null) return;

    User? user = await sl<LocalStorageRepositoryInterface>().getUser();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
            isMine: _companyPageViewModel.company?.manager?.id == user?.id,
            user: _companyPageViewModel.company!.manager!,
            onPop: (user) => _companyPageViewModel.setManager(user),
          ),
        ));
  }

  void _showSingleCompanyOnMap() {
    if (_companyPageViewModel.company == null) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleCompanyMapScreenWidget(
                company: _companyPageViewModel.company!)));
  }

  void _showCompanyEditScreen() {
    if (_companyPageViewModel.company == null) return;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyCreateScreenWidget(
              company: _companyPageViewModel.company,
              onPop: (company) => _companyPageViewModel
                  .getCompanyById(_companyPageViewModel.company!.id)),
        ));
  }

  void _showContactScreen(int index) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ContactScreenWidget(
                contact: _companyPageViewModel.company!.contacts[index],
                onDelete: (contact) =>
                    _companyPageViewModel.setContact(contact),
              )));
}
