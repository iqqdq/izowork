import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contact_create_view_model.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:izowork/views/separator_widget.dart';
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
    _contactCreateViewModel =
        Provider.of<ContactCreateViewModel>(context, listen: true);

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
        : _contactCreateViewModel.contact!.avatar == null
            ? null
            : _contactCreateViewModel.contact!.avatar!;

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
                        onTap: () => {Navigator.pop(context)})),
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
                                    imageUrl: contactAvatarUrl + _url,
                                    width: 80.0,
                                    height: 80.0,
                                    memCacheWidth: 80 *
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
                            _contactCreateViewModel.pickImage(context)),
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
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _nameFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
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
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _postFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _postTextEditingConrtoller.clear()),

                    /// COMPANY SELECTION
                    SelectionInputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        title: Titles.company,
                        value: _contactCreateViewModel.company?.name ??
                            Titles.notSelected,
                        isVertical: true,
                        onTap: () => _contactCreateViewModel
                            .showSearchCompanySheet(context)),

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
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _emailFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
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
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _phoneFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _phoneTextEditingConrtoller.clear()),

                    /// SOCIAL LIST
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10.0),
                        itemCount: _socials.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            InputWidget(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                height: 56.0,
                                textEditingController:
                                    _socials[index].textEditingController,
                                focusNode: _socials[index].focusNode,
                                textCapitalization: TextCapitalization.none,
                                placeholder: Titles.socialLink,
                                onTap: () => {
                                      setState(() => {
                                            _index = index,
                                            FocusScope.of(context).unfocus(),
                                            _socials[index]
                                                .focusNode
                                                .requestFocus()
                                          })
                                    },
                                onEditingComplete: () =>
                                    FocusScope.of(context).unfocus(),
                                onClearTap: () => _socials[index]
                                    .textEditingController
                                    .clear()),

                            /// ADD SOCIAL BUTTON
                            index == _socials.length - 1
                                ? BorderButtonWidget(
                                    title: Titles.addSocial,
                                    margin: EdgeInsets.zero,
                                    onTap: () => setState(() => {
                                          _socials[_index].focusNode.unfocus(),
                                          _socials.add(SocialInputModel(
                                              TextEditingController(),
                                              FocusNode())),
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
                            onTap: () =>
                                _contactCreateViewModel.delete(context))
                  ])),

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
                                        context,
                                        _nameTextEditingController.text,
                                        _postTextEditingConrtoller.text,
                                        _emailTextEditingConrtoller.text,
                                        _phoneTextEditingConrtoller.text,
                                        _socials)
                                    .then((value) => {
                                          if (_contactCreateViewModel.contact !=
                                              null)
                                            {
                                              widget.onPop(
                                                  _contactCreateViewModel
                                                      .contact!),
                                              Navigator.pop(context)
                                            }
                                        })
                                : _contactCreateViewModel
                                    .updateContactInfo(
                                        context,
                                        _nameTextEditingController.text,
                                        _postTextEditingConrtoller.text,
                                        _emailTextEditingConrtoller.text,
                                        _phoneTextEditingConrtoller.text,
                                        _socials)
                                    .then((value) => {
                                          if (_contactCreateViewModel.contact !=
                                              null)
                                            {
                                              widget.onPop(
                                                  _contactCreateViewModel
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
        ]));
  }
}
