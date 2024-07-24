import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/features/contact_create/view_model/contact_create_view_model.dart';
import 'package:izowork/models/models.dart';

import 'package:izowork/features/profile_edit/view/profile_edit_screen_body.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/features/search_company/view/search_company_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ContactCreateScreenBodyWidget extends StatefulWidget {
  final Function(Contact?) onPop;

  const ContactCreateScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _ContactCreateScreenBodyState createState() =>
      _ContactCreateScreenBodyState();
}

class _ContactCreateScreenBodyState
    extends State<ContactCreateScreenBodyWidget> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final TextEditingController _postTextEditingConrtoller =
      TextEditingController();
  final FocusNode _postFocusNode = FocusNode();

  final TextEditingController _emailTextEditingConrtoller =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _phoneTextEditingConrtoller =
      TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  final List<SocialInputModel> _socials = [];

  late ContactCreateViewModel _contactCreateViewModel;

  int _index = 0;
  bool _isRequesting = true;

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();
    _postTextEditingConrtoller.dispose();
    _postFocusNode.dispose();
    _emailTextEditingConrtoller.dispose();
    _emailFocusNode.dispose();
    _phoneTextEditingConrtoller.dispose();
    _phoneFocusNode.dispose();

    if (_socials.isNotEmpty) {
      for (var element in _socials) {
        element.textEditingController.dispose();
      }
    }

    widget.onPop(_contactCreateViewModel.contact);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _contactCreateViewModel = Provider.of<ContactCreateViewModel>(
      context,
      listen: true,
    );

    if (_isRequesting && _contactCreateViewModel.contact != null) {
      _isRequesting = false;
      _emailTextEditingConrtoller.text =
          _contactCreateViewModel.contact!.email ?? '';
      _nameTextEditingController.text = _contactCreateViewModel.contact!.name;
      _postTextEditingConrtoller.text =
          _contactCreateViewModel.contact!.post ?? '';
      _phoneTextEditingConrtoller.text =
          _contactCreateViewModel.contact!.phone ?? '';

      if (_contactCreateViewModel.contact!.social.isEmpty) {
        _socials.add(SocialInputModel(TextEditingController(), FocusNode()));
      } else {
        for (var element in _contactCreateViewModel.contact!.social) {
          _socials.add(SocialInputModel(
              TextEditingController(text: element), FocusNode()));
        }
      }
    } else {
      if (_isRequesting && _socials.isEmpty) {
        _socials.add(SocialInputModel(TextEditingController(), FocusNode()));
      }
    }

    String? _url = _contactCreateViewModel.contact == null
        ? _contactCreateViewModel.selectedContact?.avatar
        : _contactCreateViewModel.contact!.avatar;

    return Scaffold(
      backgroundColor: HexColors.white,
      appBar: AppBar(
          titleSpacing: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Column(children: [
            Stack(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child:
                      BackButtonWidget(onTap: () => {Navigator.pop(context)})),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                    _contactCreateViewModel.contact == null
                        ? Titles.newContact
                        : Titles.contactEdit,
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
                    bottom: MediaQuery.of(context).padding.bottom + 140.0),
                children: [
                  /// AVATAR
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AvatarWidget(
                      url: contactAvatarUrl,
                      endpoint: _url,
                      size: 80.0,
                    ),
                  ]),
                  const SizedBox(height: 24.0),

                  /// CHANGE AVATAR BUTTON
                  BorderButtonWidget(
                    title:
                        _url == null ? Titles.addAvatar : Titles.changeAvatar,
                    margin: EdgeInsets.zero,
                    onTap: () => _contactCreateViewModel.pickImage(),
                  ),
                  const SizedBox(height: 24.0),

                  /// NAME INPUT
                  InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      textEditingController: _nameTextEditingController,
                      focusNode: _nameFocusNode,
                      textCapitalization: TextCapitalization.words,
                      placeholder: Titles.fullname,
                      onTap: () => {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _nameFocusNode.requestFocus();
                            })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _nameTextEditingController.clear()),

                  /// SPECIALITY INPUT
                  InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      textEditingController: _postTextEditingConrtoller,
                      focusNode: _postFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      placeholder: Titles.speciality,
                      onTap: () => {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _postFocusNode.requestFocus();
                            })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _postTextEditingConrtoller.clear()),

                  /// COMPANY SELECTION
                  IgnorePointer(
                      ignoring: _contactCreateViewModel.selectedCompany != null,
                      child: Opacity(
                          opacity:
                              _contactCreateViewModel.selectedCompany == null
                                  ? 1.0
                                  : 0.5,
                          child: SelectionInputWidget(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              title: Titles.company,
                              value: _contactCreateViewModel.company?.name ??
                                  Titles.notSelected,
                              isVertical: true,
                              onTap: () => _showSearchCompanySheet()))),

                  /// EMAIL INPUT
                  InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      textEditingController: _emailTextEditingConrtoller,
                      focusNode: _emailFocusNode,
                      placeholder: Titles.email,
                      textInputType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      onTap: () => {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _emailFocusNode.requestFocus();
                            })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _emailTextEditingConrtoller.clear()),

                  /// PHONE
                  InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      textEditingController: _phoneTextEditingConrtoller,
                      focusNode: _phoneFocusNode,
                      textInputType: TextInputType.phone,
                      placeholder: Titles.phone,
                      onTap: () => {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _phoneFocusNode.requestFocus();
                            })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _phoneTextEditingConrtoller.clear()),

                  /// SOCIAL LIST
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 10.0),
                      itemCount: _socials.length,
                      itemBuilder: (context, index) {
                        final social = _socials[index];
                        return Column(
                            key: ValueKey(_socials[index]),
                            children: [
                              InputWidget(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  height: 56.0,
                                  textEditingController:
                                      social.textEditingController,
                                  focusNode: social.focusNode,
                                  textCapitalization: TextCapitalization.none,
                                  placeholder: Titles.socialLink,
                                  onTap: () => {
                                        setState(() {
                                          _index = index;
                                          FocusScope.of(context).unfocus();
                                          social.focusNode.requestFocus();
                                        })
                                      },
                                  onEditingComplete: () =>
                                      FocusScope.of(context).unfocus(),
                                  onClearTap: () =>
                                      social.textEditingController.clear()),

                              /// ADD SOCIAL BUTTON
                              index == _socials.length - 1
                                  ? BorderButtonWidget(
                                      title: Titles.addSocial,
                                      margin: EdgeInsets.zero,
                                      onTap: () => setState(() {
                                            _socials[_index]
                                                .focusNode
                                                .unfocus();
                                            _socials.add(SocialInputModel(
                                                TextEditingController(),
                                                FocusNode()));
                                          }))
                                  : Container()
                            ]);
                      }),
                  _contactCreateViewModel.selectedContact == null
                      ? Container()
                      : BorderButtonWidget(
                          isDestructive: true,
                          title: Titles.delete,
                          margin: EdgeInsets.zero,
                          onTap: () => _contactCreateViewModel
                              .delete()
                              .whenComplete(() => Navigator.pop(context)),
                        )
                ])),

        /// SAVE BUTTON
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom == 0.0
                        ? 12.0
                        : MediaQuery.of(context).padding.bottom),
                child: ButtonWidget(
                    title: Titles.save,
                    onTap: () => {
                          FocusScope.of(context).unfocus(),
                          _contactCreateViewModel.contact == null
                              ? _contactCreateViewModel
                                  .createNewContact(
                                    _nameTextEditingController.text,
                                    _postTextEditingConrtoller.text,
                                    _emailTextEditingConrtoller.text,
                                    _phoneTextEditingConrtoller.text,
                                    _socials,
                                  )
                                  .then((value) => {
                                        if (_contactCreateViewModel.contact !=
                                            null)
                                          {
                                            widget.onPop(_contactCreateViewModel
                                                .contact!),
                                            Navigator.pop(context)
                                          }
                                      })
                              : _contactCreateViewModel
                                  .updateContactInfo(
                                    _nameTextEditingController.text,
                                    _postTextEditingConrtoller.text,
                                    _emailTextEditingConrtoller.text,
                                    _phoneTextEditingConrtoller.text,
                                    _socials,
                                  )
                                  .then((value) => {
                                        if (_contactCreateViewModel.contact !=
                                            null)
                                          {
                                            widget.onPop(_contactCreateViewModel
                                                .contact!),
                                            Navigator.pop(context)
                                          }
                                      })
                        }))),

        const SeparatorWidget(),

        /// INDICATOR
        _contactCreateViewModel.loadingStatus == LoadingStatus.searching
            ? const LoadingIndicatorWidget()
            : Container()
      ]),
    );
  }

  // MARK: -
  // MARK: - PUSH

  void _showSearchCompanySheet() {
    Company? newCompany;

    showCupertinoModalBottomSheet(
      enableDrag: false,
      topRadius: const Radius.circular(16.0),
      barrierColor: Colors.black.withOpacity(0.6),
      backgroundColor: HexColors.white,
      context: context,
      builder: (sheetContext) => SearchCompanyScreenWidget(
          title: Titles.company,
          isRoot: true,
          onFocus: () => {},
          onPop: (company) => {
                newCompany = company,
                Navigator.pop(context),
              }),
    ).whenComplete(() => _contactCreateViewModel.changeCompany(newCompany));
  }
}
