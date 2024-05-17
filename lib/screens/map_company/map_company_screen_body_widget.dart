import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_it/get_it.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/screens/company/company_screen.dart';
import 'package:izowork/screens/profile/profile_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/views/views.dart';

class MapCompanyScreenBodyWidget extends StatefulWidget {
  final Company company;
  final bool? hideInfoButton;

  const MapCompanyScreenBodyWidget({
    Key? key,
    required this.company,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  _MapCompanyScreenBodyState createState() => _MapCompanyScreenBodyState();
}

class _MapCompanyScreenBodyState extends State<MapCompanyScreenBodyWidget> {
  late Company _company;

  @override
  void initState() {
    _company = widget.company;

    super.initState();
  }

  void _showCompanyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyScreenWidget(
          company: _company,
          onPop: (company) => setState(() => _company = company ?? _company),
        ),
      ),
    );
  }

  Future _showUserScreen() async {
    User? user = await GetIt.I<LocalStorageRepositoryInterface>().getUser();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreenWidget(
              isMine: _company.manager?.id == user?.id,
              user: _company.manager!,
              onPop: (user) => {
                    if (context.mounted) setState(() => _company.manager = user)
                  }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom == 0.0
              ? 12.0
              : MediaQuery.of(context).padding.bottom,
        ),
        color: HexColors.white,
        child: Column(children: [
          const Column(children: [
            /// DISMISS INDICATOR
            SizedBox(height: 6.0),
            DismissIndicatorWidget(),
          ]),

          /// SCROLLABLE LIST
          Expanded(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 12.0),

                  /// IMAGE
                  Center(
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: _company.image == null
                            ? SvgPicture.asset(
                                'assets/ic_avatar.svg',
                                color: HexColors.grey40,
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: CachedNetworkImage(
                                  cacheKey: _company.image!,
                                  imageUrl: companyMedialUrl + _company.image!,
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
                      title: _company.type,
                      status: _company.type == 'Поставщик'
                          ? 0
                          : _company.type == 'Проектировщик'
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
                          Text(
                            _company.manager?.name ?? '-',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PT Root UI',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ]),
                    onTap: _company.manager == null
                        ? null
                        : () => _showUserScreen(),
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
                    _company.description == null
                        ? '-'
                        : _company.description!.isEmpty
                            ? '-'
                            : _company.description!,
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
                  Text(
                    _company.address ?? '-',
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  /// PHONE
                  const TitleWidget(
                    text: Titles.phone,
                    padding: EdgeInsets.zero,
                    isSmall: true,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _company.phone ?? '-',
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
                    _company.email == null
                        ? '-'
                        : _company.email!.isEmpty
                            ? '-'
                            : _company.email!,
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
                    _company.details == null
                        ? '-'
                        : _company.details!.isEmpty
                            ? '-'
                            : _company.details!,
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
                  Text(_company.productType?.name ?? '-',
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
                    _company.successfulDeals.toString(),
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 4.0),
                  Text(
                    _company.productType?.name ?? '-',
                    style: TextStyle(
                      color: HexColors.black,
                      fontSize: 14.0,
                      fontFamily: 'PT Root UI',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ]),
          ),

          /// BOTTOM BUTTON'S
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(children: [
              /// INFO BUTTON
              widget.hideInfoButton != null
                  ? Container()
                  : Expanded(
                      child: BorderButtonWidget(
                        title: Titles.showDetail,
                        margin: EdgeInsets.zero,
                        onTap: () => _showCompanyScreen(),
                      ),
                    ),
              SizedBox(width: widget.hideInfoButton != null ? 0.0 : 12.0),

              /// CLOSE SHEET BUTTON
              Expanded(
                child: BorderButtonWidget(
                  title: Titles.close,
                  margin: EdgeInsets.zero,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
