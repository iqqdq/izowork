import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/entities/response/user.dart';
import 'package:izowork/models/company_create_view_model.dart';
import 'package:izowork/models/profile_edit_view_model.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class CompanyCreateScreenBodyWidget extends StatefulWidget {
  final Function(Company) onPop;

  const CompanyCreateScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _CompanyCreateScreenBodyState createState() =>
      _CompanyCreateScreenBodyState();
}

class _CompanyCreateScreenBodyState
    extends State<CompanyCreateScreenBodyWidget> {
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  final TextEditingController _addressTextEditingConrtoller =
      TextEditingController();
  final FocusNode _addressFocusNode = FocusNode();
  final TextEditingController _emailTextEditingConrtoller =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _phoneTextEditingConrtoller =
      TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _requisitesTextEditingController =
      TextEditingController();
  final FocusNode _requisitesFocusNode = FocusNode();
  final TextEditingController _dealsTextEditingController =
      TextEditingController();
  final FocusNode _dealsFocusNode = FocusNode();

  late CompanyCreateViewModel _companyCreateViewModel;

  @override
  void dispose() {
    _descriptionTextEditingController.dispose();
    _descriptionFocusNode.dispose();
    _addressTextEditingConrtoller.dispose();
    _addressFocusNode.dispose();
    _emailTextEditingConrtoller.dispose();
    _emailFocusNode.dispose();
    _phoneTextEditingConrtoller.dispose();
    _phoneFocusNode.dispose();
    _requisitesTextEditingController.dispose();
    _requisitesFocusNode.dispose();
    _dealsTextEditingController.dispose();
    _dealsFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _companyCreateViewModel =
        Provider.of<CompanyCreateViewModel>(context, listen: true);

    if (_companyCreateViewModel.company != null) {
      // _emailTextEditingConrtoller.text = _profileEditViewModel.user!.email;
      // _nameTextEditingConrtoller.text = _profileEditViewModel.user!.name;
      // _postTextEditingConrtoller.text = _profileEditViewModel.user!.post;
      // _phoneTextEditingConrtoller.text = _profileEditViewModel.user!.phone;
    }

    String? _url = _companyCreateViewModel.company?.image ??
        _companyCreateViewModel.selectedCompany?.image;

    return Scaffold(
        backgroundColor: HexColors.white,
        appBar: AppBar(
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
                  Text(
                      _companyCreateViewModel.selectedCompany == null
                          ? Titles.newCompany
                          : Titles.editCompany,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold))
                ])
              ])
            ])),
        body: Stack(children: [
          GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 20.0,
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 90.0
                          : MediaQuery.of(context).padding.bottom + 70.0),
                  children: [
                    /// AVATAR
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Stack(children: [
                        SvgPicture.asset('assets/ic_avatar.svg',
                            color: HexColors.grey40,
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover),
                        _url == null
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: CachedNetworkImage(
                                    cacheKey: _url,
                                    imageUrl: companyMedialUrl + _url,
                                    width: 80.0,
                                    height: 80.0,
                                    memCacheWidth: 80 *
                                        MediaQuery.of(context)
                                            .devicePixelRatio
                                            .round(),
                                    memCacheHeight: 80 *
                                        MediaQuery.of(context)
                                            .devicePixelRatio
                                            .round(),
                                    fit: BoxFit.cover)),
                      ])
                    ]),
                    const SizedBox(height: 24.0),

                    /// CHANGE AVATAR BUTTON
                    BorderButtonWidget(
                        title: _url == null
                            ? Titles.addAvatar
                            : Titles.changeAvatar,
                        margin: EdgeInsets.zero,
                        onTap: () =>
                            _companyCreateViewModel.pickImage(context)),
                    const SizedBox(height: 24.0),

                    /// DESCRTIPTION INPUT
                    InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      textEditingController: _descriptionTextEditingController,
                      focusNode: _descriptionFocusNode,
                      height: 168.0,
                      maxLines: 10,
                      placeholder: '${Titles.description}...',
                      onTap: () => setState,
                      onChange: (text) => setState,
                    ),

                    /// ADDRESS INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _addressTextEditingConrtoller,
                        focusNode: _addressFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        placeholder: Titles.address,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _addressFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () =>
                            _addressTextEditingConrtoller.clear()),

                    /// PHONE
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _phoneTextEditingConrtoller,
                        focusNode: _phoneFocusNode,
                        textInputType: TextInputType.phone,
                        placeholder: Titles.phone,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _phoneFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _phoneTextEditingConrtoller.clear()),

                    /// EMAIL INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _emailTextEditingConrtoller,
                        focusNode: _emailFocusNode,
                        placeholder: Titles.email,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _emailFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _emailTextEditingConrtoller.clear()),

                    /// REQUISITES INPUT
                    InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      textEditingController: _requisitesTextEditingController,
                      focusNode: _requisitesFocusNode,
                      height: 168.0,
                      maxLines: 10,
                      placeholder: '${Titles.requisites}...',
                      onTap: () => setState,
                      onChange: (text) => setState,
                    ),

                    /// PRODUCTS TYPE SELECTION
                    SelectionInputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        title: Titles.productsType,
                        value: _companyCreateViewModel.productType?.name ??
                            Titles.notSelected,
                        isVertical: true,
                        onTap: () => _companyCreateViewModel
                            .showProductTypeSelectionSheet(context)),

                    /// SUCCESS DEAL COUNT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _dealsTextEditingController,
                        focusNode: _dealsFocusNode,
                        textInputType: TextInputType.number,
                        placeholder: Titles.successDealCount,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _dealsFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _dealsTextEditingController.clear()),
                  ])),

          /// CREATE BUTTON
          AnimatedOpacity(
              opacity: _descriptionFocusNode.hasFocus ||
                      _addressFocusNode.hasFocus ||
                      _phoneFocusNode.hasFocus ||
                      _emailFocusNode.hasFocus ||
                      _requisitesFocusNode.hasFocus ||
                      _dealsFocusNode.hasFocus
                  ? 0.0
                  : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      child: ButtonWidget(
                          title: Titles.createCompany,
                          isDisabled: true,
                          onTap: () => {
                                // TODO CREATE COMPANY
                              })))),

          /// INDICATOR
          _companyCreateViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
