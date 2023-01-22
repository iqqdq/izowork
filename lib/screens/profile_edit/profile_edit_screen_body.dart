import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/profile_edit_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/border_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/input_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class SocialInputModel {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  SocialInputModel(this.textEditingController, this.focusNode);
}

class ProfileEditScreenBodyWidget extends StatefulWidget {
  const ProfileEditScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenBodyState createState() => _ProfileEditScreenBodyState();
}

class _ProfileEditScreenBodyState extends State<ProfileEditScreenBodyWidget> {
  final TextEditingController _nameTextEditingConrtoller =
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
  final List<SocialInputModel> _socials = [
    SocialInputModel(TextEditingController(), FocusNode())
  ];
  int _index = 0;
  late ProfileEditViewModel _profileEditViewModel;

  @override
  void dispose() {
    _nameTextEditingConrtoller.dispose();
    _postTextEditingConrtoller.dispose();
    _emailTextEditingConrtoller.dispose();
    _phoneTextEditingConrtoller.dispose();

    if (_socials.isNotEmpty) {
      for (var element in _socials) {
        element.textEditingController.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _profileEditViewModel =
        Provider.of<ProfileEditViewModel>(context, listen: true);

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
                    Center(
                        child: Stack(children: [
                      SvgPicture.asset('assets/ic_avatar.svg',
                          width: 80.0, height: 80.0, fit: BoxFit.cover),
                      //   ClipRRect(
                      //   borderRadius: BorderRadius.circular(40.0),
                      //   child:
                      // CachedNetworkImage(imageUrl: '', width: 80.0, height: 80.0, cacheWidth: 80 * (MediaQuery.of(context).devicePixelRatio).round(), cacheHeight: 80 * (MediaQuery.of(context).devicePixelRatio).round(), fit: BoxFit.cover)),
                    ])),
                    const SizedBox(height: 24.0),

                    /// CHANGE AVATAR BUTTON
                    BorderButtonWidget(
                        title: Titles.changeAvatar,
                        margin: EdgeInsets.zero,
                        onTap: () => _profileEditViewModel.setAvatar()),
                    const SizedBox(height: 24.0),

                    /// NAME INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _nameTextEditingConrtoller,
                        focusNode: _nameFocusNode,
                        placeholder: Titles.fullname,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _nameFocusNode.requestFocus()
                                  })
                            },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        onClearTap: () => _phoneTextEditingConrtoller.clear()),

                    /// POST INPUT
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _postTextEditingConrtoller,
                        focusNode: _postFocusNode,
                        placeholder: Titles.post,
                        onTap: () => {
                              setState(() => {
                                    FocusScope.of(context).unfocus(),
                                    _postFocusNode.requestFocus()
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
                        onClearTap: () => _phoneTextEditingConrtoller.clear()),

                    /// PHONE
                    InputWidget(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        height: 56.0,
                        textEditingController: _phoneTextEditingConrtoller,
                        focusNode: _phoneFocusNode,
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
                        padding: EdgeInsets.zero,
                        itemCount: _socials.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InputWidget(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  height: 56.0,
                                  textEditingController:
                                      _socials[index].textEditingController,
                                  focusNode: _socials[index].focusNode,
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
                                            _socials[_index]
                                                .focusNode
                                                .unfocus(),
                                            _socials.add(SocialInputModel(
                                                TextEditingController(),
                                                FocusNode())),
                                          }))
                                  : Container()
                            ],
                          );
                        })
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
                            // TODO UPDATE PROFILE
                            Navigator.pop(context)
                          }))),

          /// INDICATOR
          _profileEditViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
