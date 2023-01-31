import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:izowork/components/hex_colors.dart';
import 'package:izowork/components/loading_status.dart';
import 'package:izowork/components/titles.dart';
import 'package:izowork/models/profile_view_model.dart';
import 'package:izowork/views/back_button_widget.dart';
import 'package:izowork/views/button_widget_widget.dart';
import 'package:izowork/views/loading_indicator_widget.dart';
import 'package:izowork/views/separator_widget.dart';
import 'package:izowork/views/title_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreenBodyWidget extends StatefulWidget {
  final bool isMine;
  const ProfileScreenBodyWidget({Key? key, required this.isMine})
      : super(key: key);

  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBodyWidget> {
  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _profileViewModel = Provider.of<ProfileViewModel>(context, listen: true);

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
                  Text(widget.isMine ? Titles.myProfile : Titles.profile,
                      style: TextStyle(
                          color: HexColors.black,
                          fontSize: 18.0,
                          fontFamily: 'PT Root UI',
                          fontWeight: FontWeight.bold)),
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

                /// NAME
                Text(
                  'Имя Фамилия',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HexColors.black,
                      fontSize: 18.0,
                      fontFamily: 'PT Root UI',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24.0),

                /// POST
                const TitleWidget(
                    text: Titles.post,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                Text('Менеджер по продажам',
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI')),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// EMAIL
                const TitleWidget(
                    text: Titles.email,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                Text('example@mail.ru',
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI')),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// PHONE
                const TitleWidget(
                    text: Titles.phone,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                Text('+7 791 395 54 49',
                    style: TextStyle(
                        color: HexColors.black,
                        fontSize: 14.0,
                        fontFamily: 'PT Root UI')),
                const SizedBox(height: 16.0),
                const SeparatorWidget(),
                const SizedBox(height: 16.0),

                /// SOCIAL
                const TitleWidget(
                    text: Titles.socialLinks,
                    padding: EdgeInsets.only(bottom: 4.0),
                    isSmall: true),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () => _profileViewModel
                                  .openSocialUrl('https://vk.com/yuriy_tim'),
                              child: Text('https://vk.com/yuriy_tim',
                                  style: TextStyle(
                                      color: HexColors.primaryDark,
                                      fontSize: 14.0,
                                      fontFamily: 'PT Root UI',
                                      decoration: TextDecoration.underline))));
                    })
              ]),

          widget.isMine
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      child: ButtonWidget(
                          title: Titles.edit,
                          onTap: () => _profileViewModel
                              .showProfileEditScreen(context))))
              : Container(),

          /// INDICATOR
          _profileViewModel.loadingStatus == LoadingStatus.searching
              ? const LoadingIndicatorWidget()
              : Container()
        ]));
  }
}
