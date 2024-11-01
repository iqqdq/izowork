import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:izowork/components/components.dart';
import 'package:izowork/features/company/view/company_page_view_screen.dart';
import 'package:izowork/features/profile/view/profile_screen.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/injection_container.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/views/views.dart';

class MapCompanyScreenWidget extends StatefulWidget {
  final Company company;
  final bool? hideInfoButton;

  const MapCompanyScreenWidget({
    Key? key,
    required this.company,
    this.hideInfoButton,
  }) : super(key: key);

  @override
  _MapCompanyScreenState createState() => _MapCompanyScreenState();
}

class _MapCompanyScreenState extends State<MapCompanyScreenWidget> {
  late Company _company;

  @override
  void initState() {
    _company = widget.company;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          bottom: MediaQuery.of(context).padding.bottom == 0.0
              ? 12.0
              : MediaQuery.of(context).padding.bottom,
        ),
        color: HexColors.white,
        child: Column(children: [
          // const Column(children: [
          //   /// DISMISS INDICATOR
          //   SizedBox(height: 6.0),
          //   DismissIndicatorWidget(),
          // ]),

          /// TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TitleWidget(
                    padding: EdgeInsets.zero,
                    text: _company.name,
                  ),
                ),

                /// CLOSE BUTTON
                BackButtonWidget(
                  asset: 'assets/ic_close.svg',
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const SizedBox(height: 16.0),

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

                  ///  NAME
                  const TitleWidget(
                    padding: EdgeInsets.only(bottom: 4.0),
                    text: Titles.companyName,
                    isSmall: true,
                  ),
                  SubtitleWidget(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    text: _company.name,
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
                            _company.manager?.name ?? '-',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PT Root UI',
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

                  /// BIM
                  const TitleWidget(
                    text: Titles.companyBIM,
                    padding: EdgeInsets.zero,
                    isSmall: true,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _company.bim == null
                        ? '-'
                        : _company.bim!.isEmpty
                            ? '-'
                            : _company.bim!,
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
                  Text(
                    _company.productType?.name ?? '-',
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
                    _company.successfulDeals.toString(),
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
            ]),
          )
        ]),
      ),
    );
  }

  // MARK: -
  // MARK: - FUNCTIONS

  void _showCompanyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyPageViewScreenWidget(
          id: _company.id,
          onPop: (company) => _company = company ?? _company,
        ),
      ),
    ).whenComplete(() =>
        Future.delayed(const Duration(milliseconds: 500), () => setState));
  }

  Future _showUserScreen() async {
    User? user = await sl<LocalStorageRepositoryInterface>().getUser();

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
}
