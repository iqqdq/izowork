import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/entities/response/contact.dart';
import 'package:izowork/models/contact_edit_view_model.dart';
import 'package:izowork/screens/profile_edit/profile_edit_screen_body.dart';
import 'package:izowork/services/urls.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/selection_input_widget.dart';
import 'package:provider/provider.dart';

class ContactEditScreenBodyWidget extends StatefulWidget {
  final Function(Contact?) onPop;

  const ContactEditScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _ContactEditScreenBodyState createState() => _ContactEditScreenBodyState();
}

class _ContactEditScreenBodyState extends State<ContactEditScreenBodyWidget> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _specialityTextEditingConrtoller =
      TextEditingController();
  final FocusNode _specialityFocusNode = FocusNode();
  final TextEditingController _emailTextEditingConrtoller =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _phoneTextEditingConrtoller =
      TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final List<SocialInputModel> _socials = [
    SocialInputModel(TextEditingController(), FocusNode())
  ];
  late ContactEditViewModel _contactEditViewModel;

  int _index = 0;
  bool _isRequesting = true;

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _nameFocusNode.dispose();
    _specialityTextEditingConrtoller.dispose();
    _specialityFocusNode.dispose();
    _emailTextEditingConrtoller.dispose();
    _emailFocusNode.dispose();
    _phoneTextEditingConrtoller.dispose();
    _phoneFocusNode.dispose();

    if (_socials.isNotEmpty) {
      for (var element in _socials) {
        element.textEditingController.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _contactEditViewModel =
        Provider.of<ContactEditViewModel>(context, listen: true);

    if (_isRequesting && _contactEditViewModel.contact != null) {
      _isRequesting = false;
      _emailTextEditingConrtoller.text =
          _contactEditViewModel.contact!.email ?? '';
      _nameTextEditingController.text = _contactEditViewModel.contact!.name;
      // _specialityTextEditingConrtoller.text = _contactEditViewModel.contact!.speciality;
      _phoneTextEditingConrtoller.text =
          _contactEditViewModel.contact!.phone ?? '';

      if (_contactEditViewModel.contact!.social.isEmpty) {
        _socials.add(SocialInputModel(TextEditingController(), FocusNode()));
      } else {
        for (var element in _contactEditViewModel.contact!.social) {
          _socials.add(SocialInputModel(
              TextEditingController(text: element), FocusNode()));
        }
      }
    }

    String? _url = _contactEditViewModel.contact == null
        ? _contactEditViewModel.selectedContact?.avatar
        : _contactEditViewModel.contact!.avatar == null
            ? null
            : _contactEditViewModel.contact!.avatar!;

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
                        onTap: () => {
                              widget.onPop(_contactEditViewModel.contact),
                              Navigator.pop(context)
                            })),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      _contactEditViewModel.contact == null
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
                                    imageUrl: avatarUrl + _url,
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
                        onTap: () => _contactEditViewModel.pickImage(context)),
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
                        textEditingController: _specialityTextEditingConrtoller,
                        focusNode: _specialityFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        placeholder: Titles.speciality,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _specialityFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () =>
                            _specialityTextEditingConrtoller.clear()),

                    /// COMPANY SELECTION
                    SelectionInputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        title: Titles.company,
                        value: _contactEditViewModel.company?.name ??
                            Titles.notSelected,
                        isVertical: true,
                        onTap: () => _contactEditViewModel
                            .showSearchCompanyScreenSheet(context)),

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
                    _contactEditViewModel.selectedContact == null
                        ? Container()
                        : BorderButtonWidget(
                            isDestructive: true,
                            title: Titles.delete,
                            margin: EdgeInsets.zero,
                            onTap: () => _contactEditViewModel.delete(context))
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
                            _contactEditViewModel.contact == null
                                ? _contactEditViewModel
                                    .createNewContact(
                                        context,
                                        _nameTextEditingController.text,
                                        _specialityTextEditingConrtoller.text,
                                        _emailTextEditingConrtoller.text,
                                        _phoneTextEditingConrtoller.text,
                                        _socials)
                                    .then((value) => {
                                          if (_contactEditViewModel.contact !=
                                              null)
                                            {
                                              widget.onPop(_contactEditViewModel
                                                  .contact!),
                                              Navigator.pop(context)
                                            }
                                        })
                                : _contactEditViewModel
                                    .changeContactInfo(
                                        context,
                                        _nameTextEditingController.text,
                                        _specialityTextEditingConrtoller.text,
                                        _emailTextEditingConrtoller.text,
                                        _phoneTextEditingConrtoller.text,
                                        _socials)
                                    .then((value) => {
                                          if (_contactEditViewModel.contact !=
                                              null)
                                            {
                                              widget.onPop(_contactEditViewModel
                                                  .contact!),
                                              Navigator.pop(context)
                                            }
                                        })
                          }))),

          /// INDICATOR
          _contactEditViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
