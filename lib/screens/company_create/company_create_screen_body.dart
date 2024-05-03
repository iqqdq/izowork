import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/company.dart';
import 'package:izowork/models/company_create_view_model.dart';
import 'package:izowork/screens/company/company_screen.dart';
import 'package:izowork/screens/contacts/views/contact_list_item_widget.dart';
import 'package:izowork/api/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class CompanyCreateScreenBodyWidget extends StatefulWidget {
  final String? address;
  final double? lat;
  final double? long;
  final Function(Company?)? onPop;

  const CompanyCreateScreenBodyWidget({
    Key? key,
    required this.onPop,
    this.address,
    this.lat,
    this.long,
  }) : super(key: key);

  @override
  _CompanyCreateScreenBodyState createState() =>
      _CompanyCreateScreenBodyState();
}

class _CompanyCreateScreenBodyState
    extends State<CompanyCreateScreenBodyWidget> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final TextEditingController _bimTextEditingController =
      TextEditingController();
  final FocusNode _bimFocusNode = FocusNode();

  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();

  final TextEditingController _addressTextEditingController =
      TextEditingController();
  final FocusNode _addressFocusNode = FocusNode();

  final TextEditingController _coordinatesTextEditingController =
      TextEditingController();
  final FocusNode _coordinatesFocusNode = FocusNode();

  final TextEditingController _emailTextEditingConrtoller =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _requisitesTextEditingController =
      TextEditingController();
  final FocusNode _requisitesFocusNode = FocusNode();

  late CompanyCreateViewModel _companyCreateViewModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_companyCreateViewModel.company != null) {
        _nameTextEditingController.text =
            _companyCreateViewModel.company?.name ?? '';

        _bimTextEditingController.text =
            _companyCreateViewModel.company?.phone ?? '';

        _addressTextEditingController.text =
            _companyCreateViewModel.company?.address ?? '';

        _coordinatesTextEditingController.text = _companyCreateViewModel
                    .company?.lat ==
                null
            ? ''
            : '${_companyCreateViewModel.company?.lat}, ${_companyCreateViewModel.company?.long}';

        _emailTextEditingConrtoller.text =
            _companyCreateViewModel.company?.email ?? '';

        _descriptionTextEditingController.text =
            _companyCreateViewModel.company?.description ?? '';

        _requisitesTextEditingController.text =
            _companyCreateViewModel.company?.details ?? '';
      } else {
        _addressTextEditingController.text = widget.address ?? '';

        _coordinatesTextEditingController.text =
            widget.lat == null || widget.long == null
                ? ''
                : '${widget.lat}, ${widget.long}';
      }
    });
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();

    _bimTextEditingController.dispose();
    _bimFocusNode.dispose();

    _descriptionTextEditingController.dispose();
    _descriptionFocusNode.dispose();

    _addressTextEditingController.dispose();
    _addressFocusNode.dispose();

    _coordinatesTextEditingController.dispose();
    _coordinatesFocusNode.dispose();

    _emailTextEditingConrtoller.dispose();
    _emailFocusNode.dispose();

    _requisitesTextEditingController.dispose();
    _requisitesFocusNode.dispose();

    if (widget.onPop != null) {
      widget.onPop!(_companyCreateViewModel.company);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _companyCreateViewModel = Provider.of<CompanyCreateViewModel>(
      context,
      listen: true,
    );

    String? _url = _companyCreateViewModel.selectedCompany == null
        ? _companyCreateViewModel.selectedCompany?.image == null
            ? null
            : _companyCreateViewModel.selectedCompany!.image!.isEmpty
                ? null
                : _companyCreateViewModel.selectedCompany?.image
        : _companyCreateViewModel.company!.image == null
            ? null
            : _companyCreateViewModel.company!.image!.isEmpty
                ? null
                : _companyCreateViewModel.company!.image;

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
                    child: BackButtonWidget(
                      onTap: () => Navigator.pop(context),
                    )),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      _companyCreateViewModel.company == null
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

                        /// URL AVATAR
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
                                    fit: BoxFit.cover)),

                        /// FILE AVATAR
                        _companyCreateViewModel.file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: Image.file(_companyCreateViewModel.file!,
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.cover))
                            : Container(),
                      ])
                    ]),
                    const SizedBox(height: 24.0),

                    /// CHANGE AVATAR BUTTON
                    BorderButtonWidget(
                        title:
                            _url == null && _companyCreateViewModel.file == null
                                ? Titles.addAvatar
                                : Titles.changeAvatar,
                        margin: EdgeInsets.zero,
                        onTap: () =>
                            _companyCreateViewModel.pickImage(context)),
                    const SizedBox(height: 24.0),

                    /// COMPANY TYPE SELECTION
                    SelectionInputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        title: Titles.type,
                        value: _companyCreateViewModel.type ??
                            _companyCreateViewModel.company?.type ??
                            Titles.notSelected,
                        isVertical: true,
                        onTap: () => _companyCreateViewModel
                            .showCompanyTypeSelectionSheet(context)),

                    /// NAME INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _nameTextEditingController,
                        focusNode: _nameFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        placeholder: Titles.companyName,
                        onTap: () => setState(() => {
                              FocusScope.of(context).unfocus(),
                              _nameFocusNode.requestFocus()
                            }),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _nameTextEditingController.clear()),

                    /// PHONE INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _bimTextEditingController,
                        focusNode: _bimFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        textInputType: TextInputType.phone,
                        placeholder: Titles.companyBIM,
                        onTap: () => setState(() => {
                              FocusScope.of(context).unfocus(),
                              _bimFocusNode.requestFocus()
                            }),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _bimTextEditingController.clear()),

                    /// ADDRESS INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _addressTextEditingController,
                        focusNode: _addressFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        placeholder: Titles.address,
                        onTap: () => setState(() => {
                              FocusScope.of(context).unfocus(),
                              _addressFocusNode.requestFocus()
                            }),
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () =>
                            _addressTextEditingController.clear()),

                    /// COORDINATES INPUT
                    InputWidget(
                        textEditingController:
                            _coordinatesTextEditingController,
                        focusNode: _coordinatesFocusNode,
                        textInputType:
                            const TextInputType.numberWithOptions(signed: true),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        placeholder: Titles.coordinates,
                        onTap: () => setState(() {}),
                        onChange: (text) => setState(() {}),
                        onEditingComplete: () => setState(() {})),

                    /// DESCRTIPTION INPUT
                    InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      textEditingController: _descriptionTextEditingController,
                      focusNode: _descriptionFocusNode,
                      height: 168.0,
                      maxLines: 10,
                      placeholder: '${Titles.description}...',
                      onTap: () => setState(() => {
                            FocusScope.of(context).unfocus(),
                            _descriptionFocusNode.requestFocus()
                          }),
                      onChange: (text) => setState,
                    ),

                    /// EMAIL INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _emailTextEditingConrtoller,
                        focusNode: _emailFocusNode,
                        placeholder: Titles.email,
                        textInputType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        onTap: () => setState(() => {
                              FocusScope.of(context).unfocus(),
                              _emailFocusNode.requestFocus()
                            }),
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
                      onTap: () => setState(() => {
                            FocusScope.of(context).unfocus(),
                            _requisitesFocusNode.requestFocus()
                          }),
                      onChange: (text) => setState,
                    ),

                    /// PRODUCTS TYPE SELECTION
                    SelectionInputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        title: Titles.productsType,
                        value: _companyCreateViewModel.productType?.name ??
                            _companyCreateViewModel
                                .company?.productType?.name ??
                            Titles.notSelected,
                        isVertical: true,
                        onTap: () => _companyCreateViewModel
                            .showProductTypeSelectionSheet(context)),

                    _companyCreateViewModel.company == null
                        ? const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text('* ${Titles.addContactWillAllow}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14.0,
                                    fontFamily: 'PT Root UI',
                                    fontWeight: FontWeight.w500)))
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 10.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _companyCreateViewModel
                                .company?.contacts.length,
                            itemBuilder: (context, index) {
                              return ContactListItemWidget(
                                key: ValueKey(_companyCreateViewModel
                                        .company?.contacts[index] ??
                                    _companyCreateViewModel
                                        .company!.contacts[index]),
                                contact: _companyCreateViewModel
                                        .company?.contacts[index] ??
                                    _companyCreateViewModel
                                        .company!.contacts[index],
                                onContactTap: () => _companyCreateViewModel
                                    .showContactSelectionSheet(context),
                                onPhoneTap: () => {},
                                onLinkTap: (url) =>
                                    _companyCreateViewModel.openUrl(url),
                              );
                            }),

                    /// ADD CONTACT BUTTON
                    _companyCreateViewModel.company == null
                        ? Container()
                        : BorderButtonWidget(
                            title: Titles.addContact,
                            margin: EdgeInsets.only(
                                top: _companyCreateViewModel
                                        .company!.contacts.isEmpty
                                    ? 10.0
                                    : 0.0,
                                bottom: 20.0),
                            onTap: () => _companyCreateViewModel
                                .showContactSelectionSheet(context)),
                  ])),

          /// CREATE/EDIT BUTTON
          AnimatedOpacity(
            opacity: _descriptionFocusNode.hasFocus ||
                    _addressFocusNode.hasFocus ||
                    _emailFocusNode.hasFocus ||
                    _requisitesFocusNode.hasFocus
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
                  title: _companyCreateViewModel.company == null
                      ? Titles.createCompany
                      : Titles.save,
                  isDisabled: _companyCreateViewModel.company == null
                      ? _addressTextEditingController.text.isEmpty ||
                          _nameTextEditingController.text.isEmpty ||
                          _companyCreateViewModel.type == null ||
                          _bimTextEditingController.text.isEmpty
                      : _addressTextEditingController.text.isEmpty ||
                          _nameTextEditingController.text.isEmpty,
                  onTap: () =>

                      /// CREATE
                      _companyCreateViewModel.company == null
                          ? _companyCreateViewModel.createNewCompany(
                              context,
                              _addressTextEditingController.text,
                              _coordinatesTextEditingController.text,
                              _nameTextEditingController.text,
                              _companyCreateViewModel.phone ??
                                  _companyCreateViewModel
                                      .selectedCompany?.phone ??
                                  '',
                              _descriptionTextEditingController.text,
                              _requisitesTextEditingController.text,
                              _emailTextEditingConrtoller.text,
                              (company) => {
                                    if (widget.onPop == null)
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CompanyScreenWidget(
                                                    company: company,
                                                    onPop: null,
                                                  )))
                                    else
                                      {
                                        widget.onPop!(company),
                                        Navigator.pop(context)
                                      }
                                  })

                          /// UPDATE
                          : _companyCreateViewModel.editCompany(
                              context,
                              _addressTextEditingController.text,
                              _coordinatesTextEditingController.text,
                              _nameTextEditingController.text,
                              _companyCreateViewModel.phone ??
                                  _companyCreateViewModel
                                      .selectedCompany?.phone ??
                                  '',
                              _descriptionTextEditingController.text,
                              _requisitesTextEditingController.text,
                              _emailTextEditingConrtoller.text,
                              (company) => {
                                widget.onPop!(company),
                                Navigator.pop(context)
                              },
                            ),
                ),
              ),
            ),
          ),

          /// INDICATOR
          _companyCreateViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
