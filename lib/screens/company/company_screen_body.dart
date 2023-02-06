import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/company_view_model.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/filter_button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/segmented_control_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/status_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class CompanyScreenBodyWidget extends StatefulWidget {
  const CompanyScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _CompanyScreenBodyState createState() => _CompanyScreenBodyState();
}

class _CompanyScreenBodyState extends State<CompanyScreenBodyWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController(initialPage: 0);
  late CompanyViewModel _companyViewModel;
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _page() {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shrinkWrap: true,
        children: [
          /// IMAGE
          Center(
              child: Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: _companyViewModel.company.image == null
                    ? SvgPicture.asset('assets/ic_avatar.svg',
                        color: HexColors.grey40,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CachedNetworkImage(
                            imageUrl: companyMedialUrl +
                                _companyViewModel.company.image!,
                            width: 80.0,
                            height: 80.0,
                            memCacheWidth: 80 *
                                (MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            memCacheHeight: 80 *
                                (MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            fit: BoxFit.cover)))
          ])),
          const SizedBox(height: 16.0),

          /// TAG
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            StatusWidget(title: _companyViewModel.company.type, status: 0)
          ]),
          const SizedBox(height: 16.0),

          /// DESCRIPTION
          const TitleWidget(
              text: Titles.description,
              padding: EdgeInsets.zero,
              isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company.description,
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
          Text(_companyViewModel.company.address,
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// PHONE
          const TitleWidget(
              text: Titles.phone, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company.phone,
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// EMAIL
          const TitleWidget(
              text: Titles.email, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company.email,
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0),

          /// REQUISITES
          const TitleWidget(
              text: Titles.requisites, padding: EdgeInsets.zero, isSmall: true),
          const SizedBox(height: 4.0),
          Text(_companyViewModel.company.details,
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
          Text('???',
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
          Text('???',
              style: TextStyle(
                  color: HexColors.black,
                  fontSize: 14.0,
                  fontFamily: 'PT Root UI')),
          const SizedBox(height: 16.0)
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
                            // TODO SEARCH COMPANY PRODUCTS
                          },
                      onClearTap: () => {
                            // TODO CLEAR COMPANY PRODUCTS SEARCH
                          }))),
      const SizedBox(height: 8.0),
      const SeparatorWidget(),

      /// PRODUCTS LIST VIEW
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom + 70.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container();
                // return ProductsListItemWidget(
                //     tag: index.toString(),
                //     onTap: () => _companyViewModel.showProductPageScreen(
                //         context, index));
              }))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _companyViewModel = Provider.of<CompanyViewModel>(context, listen: true);

    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            toolbarHeight: _index == 0 ? 114.0 : 102.0,
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: HexColors.white90,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(height: 17.0),
              Stack(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child:
                        BackButtonWidget(onTap: () => Navigator.pop(context))),
                Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 16.0),
                    child: Center(
                        child: Text(_companyViewModel.company.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: HexColors.black,
                                fontSize: 18.0,
                                fontFamily: 'PT Root UI',
                                fontWeight: FontWeight.bold))))
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
                  onPageChanged: (page) => setState(() => _index = page))),

          /// FILTER BUTTON
          _index == 0
              ? Container()
              : SafeArea(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: FilterButtonWidget(
                            onTap: () => _companyViewModel
                                .showCompanyProductFilterSheet(context),
                            // onClearTap: () => {}
                          )))),
        ]));
  }
}
