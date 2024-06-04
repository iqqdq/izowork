import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/components.dart';
import 'package:izowork/models/models.dart';
import 'package:izowork/notifiers/notifiers.dart';
import 'package:izowork/api/api.dart';
import 'package:izowork/repositories/repositories.dart';
import 'package:izowork/screens/authorization/authorization_screen.dart';
import 'package:izowork/views/views.dart';
import 'package:provider/provider.dart';

class SocialInputModel {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  SocialInputModel(this.textEditingController, this.focusNode);
}

class ProfileEditScreenBodyWidget extends StatefulWidget {
  final Function(User) onPop;

  const ProfileEditScreenBodyWidget({Key? key, required this.onPop})
      : super(key: key);

  @override
  _ProfileEditScreenBodyState createState() => _ProfileEditScreenBodyState();
}

class _ProfileEditScreenBodyState extends State<ProfileEditScreenBodyWidget> {
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

  late ProfileEditViewModel _profileEditViewModel;

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

    if (_profileEditViewModel.user != null) {
      widget.onPop(_profileEditViewModel.user!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _profileEditViewModel = Provider.of<ProfileEditViewModel>(
      context,
      listen: true,
    );

    if (_isRequesting && _profileEditViewModel.user != null) {
      _isRequesting = false;
      _emailTextEditingConrtoller.text = _profileEditViewModel.user!.email;
      _nameTextEditingController.text = _profileEditViewModel.user!.name;
      _postTextEditingConrtoller.text = _profileEditViewModel.user!.post;
      _phoneTextEditingConrtoller.text = _profileEditViewModel.user!.phone;

      if (_profileEditViewModel.user!.social.isEmpty) {
        _socials.add(SocialInputModel(TextEditingController(), FocusNode()));
      } else {
        for (var element in _profileEditViewModel.user!.social) {
          _socials.add(SocialInputModel(
              TextEditingController(text: element), FocusNode()));
        }
      }
    }

    String? _url = _profileEditViewModel.user == null
        ? _profileEditViewModel.currentUser.avatar == null
            ? null
            : _profileEditViewModel.currentUser.avatar!.isEmpty
                ? null
                : _profileEditViewModel.currentUser.avatar
        : _profileEditViewModel.user!.avatar == null
            ? null
            : _profileEditViewModel.user!.avatar!.isEmpty
                ? null
                : _profileEditViewModel.user!.avatar;

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
                Text(Titles.profileEdit,
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
                          colorFilter: ColorFilter.mode(
                            HexColors.grey40,
                            BlendMode.srcIn,
                          ),
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
                                  fit: BoxFit.cover)),
                    ])
                  ]),
                  const SizedBox(height: 24.0),

                  /// CHANGE AVATAR BUTTON
                  BorderButtonWidget(
                    title:
                        _url == null ? Titles.addAvatar : Titles.changeAvatar,
                    margin: EdgeInsets.zero,
                    onTap: () => _profileEditViewModel.pickImage(),
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
                            setState(() => {
                                  FocusScope.of(context).unfocus(),
                                  _nameFocusNode.requestFocus()
                                })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _nameTextEditingController.clear()),

                  /// POST INPUT
                  InputWidget(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      height: 56.0,
                      textEditingController: _postTextEditingConrtoller,
                      focusNode: _postFocusNode,
                      textCapitalization: TextCapitalization.sentences,
                      placeholder: Titles.post,
                      onTap: () => {
                            setState(() => {
                                  FocusScope.of(context).unfocus(),
                                  _postFocusNode.requestFocus()
                                })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _postTextEditingConrtoller.clear()),

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
                            setState(() => {
                                  FocusScope.of(context).unfocus(),
                                  _phoneFocusNode.requestFocus()
                                })
                          },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      onClearTap: () => _phoneTextEditingConrtoller.clear()),

                  /// SOCIAL LIST
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _socials.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          InputWidget(
                              key: ValueKey(_socials[index]),
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
                                  margin: const EdgeInsets.only(top: 10.0),
                                  onTap: () => setState(() => {
                                        _socials[_index].focusNode.unfocus(),
                                        _socials.add(SocialInputModel(
                                            TextEditingController(),
                                            FocusNode())),
                                      }))
                              : Container()
                        ]);
                      }),

                  /// DELETE ACCOUNT BUTTON
                  BorderButtonWidget(
                      title: Titles.deleteAccount,
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      isDestructive: true,
                      onTap: () => _showDeleteAccountDialog())
                ])),

        /// SAVE CHANGES BUTTON
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
                          _profileEditViewModel
                              .changeUserInfo(
                                  _nameTextEditingController.text,
                                  _postTextEditingConrtoller.text,
                                  _emailTextEditingConrtoller.text,
                                  _phoneTextEditingConrtoller.text,
                                  _socials)
                              .then((value) => {
                                    if (_profileEditViewModel.user != null)
                                      {
                                        widget
                                            .onPop(_profileEditViewModel.user!),
                                        Navigator.pop(context)
                                      }
                                  })
                        }))),

        /// INDICATOR
        _profileEditViewModel.loadingStatus == LoadingStatus.searching
            ? const LoadingIndicatorWidget()
            : Container()
      ]),
    );
  }

  // MARK: -
  // MARK: - ACTIONS

  Future _showDeleteAccountDialog() async => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
            title: Text(
              Titles.deleteAccountAreYouSure,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HexColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              Row(children: [
                Expanded(
                  child: BorderButtonWidget(
                    margin: EdgeInsets.zero,
                    title: Titles.deleteAccount,
                    isDestructive: true,
                    onTap: () => _profileEditViewModel
                        .deleteAccount(context)
                        .whenComplete(() => {
                              if (_profileEditViewModel.loadingStatus ==
                                  LoadingStatus.completed)
                                {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthorizationScreenWidget()),
                                      (route) => false)
                                }
                            }),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: BorderButtonWidget(
                    margin: EdgeInsets.zero,
                    title: Titles.cancel,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ]),
            ]),
      );
}
