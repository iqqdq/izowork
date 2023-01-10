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
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:provider/provider.dart';

class ProfileEditScreenBodyWidget extends StatefulWidget {
  const ProfileEditScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _ProfileEditScreenBodyState createState() => _ProfileEditScreenBodyState();
}

class _ProfileEditScreenBodyState extends State<ProfileEditScreenBodyWidget> {
  late ProfileEditViewModel _profileEditViewModel;

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
          ListView(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 20.0,
                  bottom: MediaQuery.of(context).padding.bottom + 60.0),
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
                const SizedBox(height: 14.0),

                /// CHANGE AVATAR BUTTON
                BorderButtonWidget(
                    title: Titles.changeAvatar,
                    margin: EdgeInsets.zero,
                    onTap: () => _profileEditViewModel.setAvatar()),
                const SizedBox(height: 24.0),

                /// PASSWORD
              ]),

          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom == 0.0
                          ? 12.0
                          : MediaQuery.of(context).padding.bottom),
                  child: ButtonWidget(title: Titles.save, onTap: () => {}))),

          /// INDICATOR
          _profileEditViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
